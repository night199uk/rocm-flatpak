# Vendored from buildstream-plugins-community, pending upstream MR !511.
#
#  Copyright (C) 2026 The BuildStream Community Contributors
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library. If not, see <http://www.gnu.org/licenses/>.
"""
dvc - stage DVC-tracked large files on top of a git checkout
=============================================================

**Host dependencies:**

- ``dvc``

**Usage:**

.. code:: yaml

   # 1. git_repo pulls the repository. The .dvc files (not the actual
   #    large data) are checked out.
   - kind: git_repo
     url: upstream:myproject.git
     ref: abc123def456...

   # 2. dvc downloads the actual large data files tracked by DVC.
   - kind: dvc
     # The ref is a sha256 computed from all tracked file paths + hashes,
     # updated automatically when tracking.
     ref: <sha256-of-dvc-state>

     # Optionally specify which DVC remote to pull from. If not set,
     # the default DVC remote is used.
     # dvc-remote: mystorage

**How it works:**

DVC (Data Version Control) tracks large files by committing small
placeholder files with the ``.dvc`` extension.  These files describe
large data (typically stored in separate remote storage such as S3,
GCS or SSH) via hashes.  Example::

   outs:
   - md5: ec1d2935f811b77cc49b031b999cbf17
     path: data/foo.parquet
     size: 1048576

This source plugin reads all ``.dvc`` files from the git checkout,
collects the ``(path, hash)`` pairs, computes a deterministic ref, and
uses ``dvc pull`` to download and materialize the actual data files.

The checkout may contain git submodules, each of which can be its own
DVC repository.  A DVC repository is identified by a ``.dvc`` metadata
directory at its root.  The plugin runs ``dvc pull`` inside every such
DVC repository, so data tracked by submodules is pulled from the correct
repository.  ``.dvc`` files that are not inside a DVC repository are
ignored.

During fetch(), the pulled files are cached in a per-source mirror
directory.  During stage(), these files are copied over the placeholders
left behind by the preceding ``git_repo`` source.

**Important:** The preceding ``git_repo`` source must stage the ``.dvc``
files (i.e. not have the large data already present).  DVC downloads the
data into the working tree during ``dvc pull``.
"""

import hashlib
import os
import shutil

import ruamel.yaml

from buildstream import Source, SourceError, utils


def _find_dvc_root(start_directory, stop_directory):
    """
    Return the DVC repository root containing *start_directory*.

    DVC marks the root of a repository with a ``.dvc`` metadata
    directory. When a checkout contains several git submodules, each
    submodule that is itself a DVC repository has its own ``.dvc``
    directory, so walking upwards from a ``.dvc`` file finds the correct
    repository to run ``dvc pull`` in.

    Args:
        start_directory (str): directory containing a ``*.dvc`` file
        stop_directory (str): do not search above this directory (the
            top level of the staged checkout)

    Returns:
        The absolute path to the DVC repo root, or ``None`` if none is
        found by the time the search reaches *stop_directory*.
    """
    stop = os.path.abspath(stop_directory)
    current = os.path.abspath(start_directory)
    while True:
        if os.path.isdir(os.path.join(current, ".dvc")):
            return current
        if current == stop:
            return None
        parent = os.path.dirname(current)
        if parent == current:  # reached the filesystem root
            return None
        current = parent


def _read_dvc_files(directory):
    """
    Walk *directory* and parse every ``*.dvc`` file found.

    Returns a list of dicts, each containing:
      - ``path``:     path of the tracked file/dir relative to *directory*
      - ``md5``:      hash stored in the .dvc file
      - ``size``:     size in bytes (if present)
      - ``dvc_root``: path of the DVC repository that owns the tracked
        file, relative to *directory* (used to run ``dvc pull`` in the
        right submodule)
    """
    results = []
    top = os.path.abspath(directory)
    for root, dirs, files in os.walk(directory):
        # Skip DVC metadata directories (tracked out of Git).
        if dirs:
            dirs[:] = [d for d in dirs if d != ".dvc"]
        for fname in files:
            if not fname.endswith(".dvc"):
                continue
            dvc_path = os.path.join(root, fname)
            try:
                yaml = ruamel.yaml.YAML(typ="safe", pure=True)
                with open(dvc_path, "r", encoding="utf-8") as f:
                    data = yaml.load(f)
            except (OSError, UnicodeDecodeError, ruamel.yaml.YAMLError):
                continue

            if not data or "outs" not in data:
                continue

            dvc_root = _find_dvc_root(os.path.abspath(root), top)
            if dvc_root is not None:
                dvc_root = os.path.relpath(dvc_root, top)

            for out in data["outs"]:
                md5 = out.get("md5") or out.get("checksum") or out.get(
                    "etag"
                )
                if not md5:
                    continue
                tracked_path = os.path.join(
                    root, out.get("path", "")
                )
                results.append(
                    {
                        "path": os.path.relpath(tracked_path, directory),
                        "md5": md5,
                        "size": out.get("size", 0),
                        "dvc_root": dvc_root,
                    }
                )
    return results


def _compute_ref(dvc_entries):
    """
    Compute a deterministic ref string from a list of DVC entry dicts.

    The ref is the sha256 of the sorted concatenation of ``path + md5``
    pairs, so it is stable for the same set of tracked data.
    """
    blob = "".join(
        sorted(e["path"] + e["md5"] for e in dvc_entries)
    ).encode("utf-8")
    return hashlib.sha256(blob).hexdigest()


class DvcSource(Source):
    BST_MIN_VERSION = "2.8"

    # We need the git checkout from a preceding git_repo source to read
    # the .dvc files.
    BST_REQUIRES_PREVIOUS_SOURCES_TRACK = True
    BST_REQUIRES_PREVIOUS_SOURCES_FETCH = True

    def configure(self, node):
        CONFIG_KEYS = [
            "ref",
            "dvc-remote",
        ]
        node.validate_keys(Source.COMMON_CONFIG_KEYS + CONFIG_KEYS)

        self.ref = None
        self.load_ref(node)

        self.dvc_remote = node.get_str("dvc-remote", None)
        self._dvc_entries = []

    def preflight(self):
        # Check for dvc
        self.host_dvc = utils.get_host_tool("dvc")

    def get_unique_key(self):
        return {
            "ref": self.ref,
            "dvc-remote": self.dvc_remote,
        }

    def is_cached(self):
        return os.path.isdir(self._mirror_directory())

    # loading and saving refs
    def load_ref(self, node):
        if "ref" in node:
            self.ref = node.get_str("ref")

    def get_ref(self):
        return self.ref

    def set_ref(self, ref, node):
        self.ref = ref
        node["ref"] = ref

    # ------------------------------------------------------------------ #
    #  Track — compute a new ref from the .dvc files                      #
    # ------------------------------------------------------------------ #

    def track(self, previous_sources_dir):
        if previous_sources_dir is None:
            raise SourceError(
                "dvc source requires a git_repo (or similar) source "
                "to appear before it in the element's source list"
            )

        dvc_entries = _read_dvc_files(previous_sources_dir)
        # Entries not inside any DVC repository cannot be pulled, so they
        # must not contribute to the ref (fetch() skips them too).
        dvc_entries = [e for e in dvc_entries if e["dvc_root"] is not None]
        self._dvc_entries = dvc_entries

        if not dvc_entries:
            self.warn(
                "No .dvc files found in the git checkout",
                detail=(
                    "The dvc source will produce an empty ref. Check "
                    "that the repository actually uses DVC for data "
                    "tracking."
                ),
            )
            return _compute_ref([])

        return _compute_ref(dvc_entries)

    # ------------------------------------------------------------------ #
    #  Fetch — pull DVC-tracked large files from remote storage            #
    # ------------------------------------------------------------------ #

    def fetch(self, previous_sources_dir):
        if self.ref is None:
            raise SourceError("dvc source has no ref — cannot fetch")

        if previous_sources_dir is None:
            raise SourceError(
                "dvc source requires a previous git source to be staged "
                "before fetching"
            )

        dvc_entries = _read_dvc_files(previous_sources_dir)
        self._dvc_entries = dvc_entries

        if not dvc_entries:
            self.status("No DVC-tracked files found, nothing to fetch")
            # Create an empty mirror so stage() is a no-op.
            mirror = self._mirror_directory()
            os.makedirs(mirror, exist_ok=True)
            return

        self.status(
            "Pulling {} DVC-tracked file(s)".format(len(dvc_entries)),
            detail="\n".join(e["path"] for e in dvc_entries),
        )

        # Group the tracked files by the DVC repository that owns them.
        # The staged checkout may contain git submodules that are each
        # their own DVC repository, and ``dvc pull`` must run inside each
        # of those repositories separately.
        by_root = {}
        for entry in dvc_entries:
            root = entry["dvc_root"]
            if root is None:
                self.warn(
                    "Ignoring DVC-tracked file '{}': it is not inside a "
                    "DVC repository".format(entry["path"])
                )
                continue
            by_root.setdefault(root, []).append(entry)

        for root, entries in by_root.items():
            # dvc_root is relative to previous_sources_dir; compute the
            # tracked paths relative to that DVC repository root.
            root_abs = os.path.join(previous_sources_dir, root)
            rel_entries = [os.path.relpath(e["path"], root) for e in entries]

            cmd = [self.host_dvc, "pull", "--force"]
            if self.dvc_remote:
                cmd += ["--remote", self.dvc_remote]
            cmd += rel_entries

            self.call(
                cmd,
                fail="Failed to pull DVC-tracked files",
                cwd=root_abs,
            )

            # Verify the pulled files are present
            for entry in entries:
                full = os.path.join(previous_sources_dir, entry["path"])
                if not os.path.exists(full):
                    raise SourceError(
                        "DVC-tracked file '{}' is missing after "
                        "pull".format(entry["path"])
                    )

        # Cache the materialized files in a per-source mirror directory.
        # The previous_sources_dir is temporary, so we keep our own copy
        # to serve from during stage() at build time.
        mirror = self._mirror_directory()
        if os.path.exists(mirror):
            shutil.rmtree(mirror)
        os.makedirs(mirror, exist_ok=True)
        for entry in dvc_entries:
            if entry["dvc_root"] is None:
                continue
            src = os.path.join(previous_sources_dir, entry["path"])
            dest = os.path.join(mirror, entry["path"])
            if os.path.isdir(src):
                shutil.copytree(src, dest, dirs_exist_ok=True)
            else:
                os.makedirs(os.path.dirname(dest), exist_ok=True)
                shutil.copy2(src, dest)

        self.status(
            "Successfully pulled {} DVC-tracked file(s)".format(
                len(dvc_entries)
            )
        )

    # ------------------------------------------------------------------ #
    #  Stage — copy the pulled DVC files into the build                    #
    # ------------------------------------------------------------------ #

    def stage(self, directory):
        mirror = self._mirror_directory()
        if not os.path.isdir(mirror):
            raise SourceError(
                "dvc source has not been fetched. "
                "Run 'bst source fetch' first."
            )

        # Copy the DVC-tracked files over the placeholders left behind
        # by the preceding git_repo source.
        shutil.copytree(mirror, directory, dirs_exist_ok=True)

    # ------------------------------------------------------------------ #
    #  Workspace support                                                   #
    # ------------------------------------------------------------------ #

    def init_workspace(self, directory):
        self.host_dvc = utils.get_host_tool("dvc")
        # Materialize the DVC-tracked files in each DVC repository
        # present in the workspace (the top-level repo and any git
        # submodule that is itself a DVC repository).
        for dvc_root in self._discover_dvc_roots(directory):
            cmd = [self.host_dvc, "checkout"]
            self.call(
                cmd,
                fail="Failed to checkout DVC-tracked files",
                cwd=dvc_root,
            )

    def _discover_dvc_roots(self, directory):
        """
        Return the paths of all DVC repositories found within *directory*.

        A directory is a DVC repository if it contains a ``.dvc``
        metadata directory. Subdirectories of a DVC repository that are
        themselves DVC repositories (git submodules) are returned as
        well.
        """
        roots = []
        for root, dirs, files in os.walk(directory):
            if ".dvc" in dirs:
                roots.append(root)
                # Do not recurse into DVC repositories nested inside
                # this one; they are discovered as their own roots.
                dirs[:] = [d for d in dirs if d != ".dvc"]
        return roots

    # ------------------------------------------------------------------ #
    #  Helpers                                                             #
    # ------------------------------------------------------------------ #

    def _mirror_directory(self):
        """
        Return the per-source directory used to cache the pulled DVC
        files between fetch() and stage().

        The directory is derived from the unique key, so each distinct
        set of DVC-tracked files gets its own cache entry.
        """
        import json

        digest = hashlib.sha256(
            json.dumps(self.get_unique_key(), sort_keys=True).encode("utf-8")
        ).hexdigest()
        return os.path.join(self.get_mirror_directory(), digest)


def setup():
    return DvcSource
