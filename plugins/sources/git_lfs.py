# Vendored from buildstream-plugins-community, pending upstream MR !510.
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
git_lfs - stage Git-LFS tracked large files on top of a git checkout
====================================================================

**Host dependencies:**

- ``git``
- ``git-lfs``

**Usage:**

.. code:: yaml

   # 1. git_repo pulls the repository. LFS pointer files (not actual
   #    content) are checked out.
   - kind: git_repo
     url: upstream:myproject.git
     ref: abc123def456...

   # 2. git_lfs downloads the actual large file contents referenced by
   #    the LFS pointer files.
   - kind: git_lfs
     # The ref is a sha256 computed from all LFS object ids + paths,
     # updated automatically when tracking.
     ref: <sha256-of-lfs-state>

     # Optionally specify which git remote to fetch LFS objects from.
     # If not set, the origin remote is used.
     # lfs-remote: origin

     # Optionally specify the repository url. This is used to set the
     # origin remote of the checkout so that git-lfs can locate the
     # LFS server. If the preceding git_repo source already leaves a
     # usable remote in place, this is not required.
     # url: upstream:myproject.git

**How it works:**

Git-LFS replaces large files in the repository with small *pointer files*
during ``git add``.  These pointer files are committed to Git and checked
out by the preceding ``git_repo`` source.  The pointer file format is::

   version https://git-lfs.github.com/spec/v1
   oid sha256:<40-char hex>
   size <bytes>

This source plugin reads those pointer files from the git checkout,
collects all ``(oid, path)`` pairs, computes a deterministic ref, and
uses ``git lfs fetch`` + ``git lfs checkout`` to download and materialize
the actual file contents.

During fetch(), the materialized files are cached in a per-source mirror
directory.  During stage(), these files are copied over the pointer files
left behind by the preceding ``git_repo`` source, so the actual large
file contents are available in the build.

**Important:** The preceding ``git_repo`` source must stage LFS pointer
files (i.e. not have smudged them into full objects).  If the files have
already been smudged, this plugin will simply find no pointer files and
stage nothing.

**Configurable warnings:**

This plugin provides the following `configurable warnings
<https://docs.buildstream.build/master/format_project.html#configurable-warnings>`_:

- ``git:unused-lfs`` - The repository contains Git-LFS attributes but the
  git_lfs plugin did not find any LFS pointer files to stage.
"""

import hashlib
import os
import re
import shutil

from buildstream import Source, SourceError, utils

GIT_ATTRIBUTES = ".gitattributes"

# Configurable warning token
WARN_UNUSED_GITLFS = "unused-lfs"

POINTER_LINE_RE = re.compile(
    r'^(?P<key>[a-z0-9._-]+)\s+(?P<value>.+)$'
)

LFS_OID_RE = re.compile(
    r'^sha256:([0-9a-f]{64})$'
)


def _parse_pointer_file(path):
    """
    Parse a single LFS pointer file.

    Returns a dict with ``oid``, ``size``, and ``path`` (derived from the
    *path* argument), or ``None`` if the file is not a valid pointer file.
    """
    try:
        with open(path, "r", encoding="utf-8") as f:
            lines = f.readlines()
    except (OSError, UnicodeDecodeError):
        return None

    if not lines or not lines[0].startswith("version "):
        return None

    info = {}
    for line in lines[1:]:
        line = line.rstrip("\n")
        if not line:
            continue
        m = POINTER_LINE_RE.match(line)
        if m:
            info[m.group("key")] = m.group("value")

    if "oid" not in info or "size" not in info:
        return None

    if not LFS_OID_RE.match(info["oid"]):
        return None

    return {
        "oid": info["oid"],
        "size": int(info["size"]),
        "path": path,
    }


def _read_lfs_pointers(directory):
    """
    Walk *directory* and find all LFS pointer files.

    Returns a list of dicts with ``oid``, ``size``, and ``path``
    (relative to *directory*).
    """
    results = []
    for root, dirs, files in os.walk(directory):
        if ".git" in dirs:
            dirs.remove(".git")
        for fname in files:
            full = os.path.join(root, fname)
            info = _parse_pointer_file(full)
            if info:
                info["path"] = os.path.relpath(full, directory)
                results.append(info)
    return results


def _compute_ref(lfs_entries):
    """
    Compute a deterministic ref string from a list of LFS entry dicts.

    The ref is the sha256 of the sorted concatenation of ``oid + path``
    pairs, so it is stable for the same set of tracked files.
    """
    blob = "".join(
        sorted(e["oid"] + e["path"] for e in lfs_entries)
    ).encode("utf-8")
    return hashlib.sha256(blob).hexdigest()


class GitLfsSource(Source):
    BST_MIN_VERSION = "2.8"

    # We need the git checkout from a preceding git_repo source to read
    # the pointer files and .gitattributes.
    BST_REQUIRES_PREVIOUS_SOURCES_TRACK = True
    BST_REQUIRES_PREVIOUS_SOURCES_FETCH = True

    def configure(self, node):
        CONFIG_KEYS = [
            "ref",
            "url",
            "lfs-remote",
        ]
        node.validate_keys(Source.COMMON_CONFIG_KEYS + CONFIG_KEYS)

        self.ref = None
        self.load_ref(node)

        self.url = node.get_str("url", None)
        if self.url is not None:
            self.mark_download_url(self.url)
        self.lfs_remote = node.get_str("lfs-remote", None)
        self.host_git = None
        self._lfs_entries = []

    def preflight(self):
        # Check for git
        self.host_git = utils.get_host_tool("git")

        # Check for git-lfs
        self.call(
            [self.host_git, "lfs", "--version"],
            fail="Git LFS is not installed. "
            "Please install it: https://git-lfs.github.com/",
        )

    def get_unique_key(self):
        return {
            "ref": self.ref,
            "url": self.url,
            "lfs-remote": self.lfs_remote,
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
    #  Track — compute a new ref from the LFS pointer files                #
    # ------------------------------------------------------------------ #

    def track(self, previous_sources_dir):
        if previous_sources_dir is None:
            raise SourceError(
                "git_lfs source requires a git_repo (or similar) source "
                "to appear before it in the element's source list"
            )

        self._check_lfs_attributes(previous_sources_dir)

        lfs_entries = _read_lfs_pointers(previous_sources_dir)
        self._lfs_entries = lfs_entries

        if not lfs_entries:
            self.warn(
                "No LFS pointer files found in the git checkout",
                warning_token=WARN_UNUSED_GITLFS,
            )
            return _compute_ref([])

        return _compute_ref(lfs_entries)

    # ------------------------------------------------------------------ #
    #  Fetch — download LFS objects from remote storage                    #
    # ------------------------------------------------------------------ #

    def fetch(self, previous_sources_dir):
        if self.ref is None:
            raise SourceError("git_lfs source has no ref — cannot fetch")

        if previous_sources_dir is None:
            raise SourceError(
                "git_lfs source requires a previous git source to be "
                "staged before fetching"
            )

        self._check_lfs_attributes(previous_sources_dir)

        lfs_entries = _read_lfs_pointers(previous_sources_dir)
        self._lfs_entries = lfs_entries

        if not lfs_entries:
            self.status("No LFS-tracked files found, nothing to fetch")
            # Create an empty mirror so stage() is a no-op.
            mirror = self._mirror_directory()
            os.makedirs(mirror, exist_ok=True)
            return

        self.status(
            "Fetching {} LFS object(s)".format(len(lfs_entries)),
            detail="\n".join(e["path"] for e in lfs_entries),
        )

        # git-lfs cannot fetch from a bare file-based mirror; it needs an
        # HTTP/SSH server.  Point origin at the real remote URL before
        # fetching, mirroring git_tag's GitTagMirror.set_origin_url().
        self._set_origin_url(previous_sources_dir)

        # Fetch objects into the local LFS cache
        self.call(
            ["git", "lfs", "fetch"]
            + ([self.lfs_remote] if self.lfs_remote else []),
            fail="Failed to fetch Git LFS objects",
            cwd=previous_sources_dir,
        )

        # Checkout — replace pointer files with actual content
        self.call(
            ["git", "lfs", "checkout"],
            fail="Failed to checkout Git LFS objects",
            cwd=previous_sources_dir,
        )

        # Verify files are present
        for entry in lfs_entries:
            full = os.path.join(previous_sources_dir, entry["path"])
            if not os.path.exists(full):
                raise SourceError(
                    "LFS file '{}' is missing after checkout".format(
                        entry["path"]
                    )
                )

        # Cache the materialized files in a per-source mirror directory.
        # The previous_sources_dir is temporary, so we keep our own copy
        # to serve from during stage() at build time.
        mirror = self._mirror_directory()
        if os.path.exists(mirror):
            shutil.rmtree(mirror)
        os.makedirs(mirror, exist_ok=True)
        for entry in lfs_entries:
            src = os.path.join(previous_sources_dir, entry["path"])
            dest = os.path.join(mirror, entry["path"])
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            shutil.copy2(src, dest)

        self.status(
            "Successfully fetched {} LFS object(s)".format(
                len(lfs_entries)
            )
        )

    # ------------------------------------------------------------------ #
    #  Stage — copy the materialized LFS files into the build               #
    # ------------------------------------------------------------------ #

    def stage(self, directory):
        mirror = self._mirror_directory()
        if not os.path.isdir(mirror):
            raise SourceError(
                "git_lfs source has not been fetched. "
                "Run 'bst source fetch' first."
            )

        # Copy the LFS files over the pointer files left behind by the
        # preceding git_repo source.
        shutil.copytree(mirror, directory, dirs_exist_ok=True)

    # ------------------------------------------------------------------ #
    #  Workspace support                                                   #
    # ------------------------------------------------------------------ #

    def init_workspace(self, directory):
        self._set_origin_url(directory)
        self.call(
            ["git", "lfs", "checkout"],
            fail="Failed to checkout Git LFS objects",
            cwd=directory,
        )

    # ------------------------------------------------------------------ #
    #  Helpers                                                             #
    # ------------------------------------------------------------------ #

    def _mirror_directory(self):
        """
        Return the per-source directory used to cache materialized LFS
        files between fetch() and stage().

        The directory is derived from the unique key, so each distinct
        set of LFS files gets its own cache entry.
        """
        import json

        digest = hashlib.sha256(
            json.dumps(self.get_unique_key(), sort_keys=True).encode("utf-8")
        ).hexdigest()
        return os.path.join(self.get_mirror_directory(), digest)

    def _check_lfs_attributes(self, directory):
        """
        Detect whether the repository declares Git-LFS attributes and warn
        if no pointer files were found to stage.
        """
        gitattributes_path = os.path.join(directory, GIT_ATTRIBUTES)
        if not os.path.exists(gitattributes_path):
            return

        try:
            with open(gitattributes_path, "r", encoding="utf-8") as f:
                content = f.read()
        except OSError:
            return

        has_lfs = (
            "filter=lfs" in content
            or "diff=lfs" in content
            or "merge=lfs" in content
        )

        if has_lfs:
            self.info(
                "Git-LFS attributes detected in .gitattributes",
                detail=(
                    "The git_lfs source will download the actual file "
                    "contents from the configured LFS remote."
                ),
            )

    def _set_origin_url(self, directory):
        """
        Ensure ``remote.origin.url`` points at a real LFS-servable remote
        rather than a local bare mirror path.

        This is required because git-lfs cannot retrieve objects from a
        file-based directory.  Mirror the pattern from git_tag's
        ``GitTagMirror.set_origin_url()``.
        """
        # If the user provided a URL, point origin at it directly.
        if self.url is not None:
            url = self.translate_url(self.url)
            self.call(
                [self.host_git, "remote", "set-url", "origin", url],
                fail="Failed to set origin url to {}".format(url),
                cwd=directory,
            )
            return

        exit_code, output = self.check_output(
            [self.host_git, "config", "--get", "remote.origin.url"],
            cwd=directory,
        )

        # No origin configured at all — nothing we can do but let the
        # subsequent git lfs command report the error.
        if exit_code != 0:
            return

        origin_url = output.strip()

        if origin_url.startswith(("http://", "https://", "ssh://",
                                 "git://", "git@")):
            return

        # The origin is a local path (likely a bare mirror), which
        # git-lfs cannot serve from. Warn and proceed; git lfs fetch
        # will report the failure with a useful message.
        self.warn(
            "Git-LFS origin appears to be a local path: {}".format(
                origin_url
            ),
            detail=(
                "git-lfs cannot retrieve objects from a file-based "
                "mirror. Consider setting the 'url' configuration option "
                "on this source to the real repository URL."
            ),
        )


def setup():
    return GitLfsSource
