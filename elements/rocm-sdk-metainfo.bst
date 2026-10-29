kind: manual

build-depends:
- freedesktop-sdk.bst:components/appstream-minimal.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/m4.bst
- freedesktop-sdk.bst:components/stripper.bst

depends:
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:bootstrap/coreutils.bst

variables:
  prefix: "%{rocm-prefix}"
  datadir: "%{prefix}/share"
  app-id: >-
    org.freedesktop.Platform.amd.ROCm

config:
  install-commands:
  - |
    pwd
    ls -la
    set -e
    appdata_dir=%{install-root}%{datadir}/metainfo
    mkdir -p ${appdata_dir}
    CURRENT_REF=$(git describe --tags --match therock-*)
    FMT='
        refname=%(refname:short)
        creatordate=%(creatordate:short)
        echo "    <release version=\"${refname/therock-/}\" date=\"${creatordate}\"/>"
    '
    RELEASES_TMP=$(git for-each-ref --shell --format="$FMT" --sort='-creatordate' --merged="${CURRENT_REF}" 'refs/tags/therock-*')
    RELEASES=`eval "${RELEASES_TMP}"`
    for app_id in %{app-id}
    do
      m4 \
      -D__APP_ID__="${app_id}" \
      -D__RELEASES__="${RELEASES}" \
      appdata.template > ${appdata_dir}/${app_id}.appdata.xml
      appstreamcli compose \
        --components ${app_id} \
        --prefix %{prefix} \
        --result-root %{install-root} \
        --data-dir %{install-root}%{prefix}/share/app-info/xmls \
        --origin ${app_id} \
        %{install-root}
    done

sources:
- kind: git_tag
  url: rocm:TheRock
  track: "%{rocmtag}"
  checkout-submodules: false
  full-clone: false
  ref: therock-7.14-0-g418cd5f63abb7a604bad5874cd7b2e29334e640f
- kind: local
  path: files/appdata.template
