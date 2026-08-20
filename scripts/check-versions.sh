#!/usr/bin/env bash
# Compare the tool versions pinned in docker-bake.hcl against upstream latest.
set -euo pipefail

cd "$(dirname "$0")/.."

BAKE=docker-bake.hcl
WRITE=false
[ "${1:-}" = "--write" ] && WRITE=true

# bake variable | display name | upstream source
#   gh:<owner>/<repo>  latest release tag (leading "v" stripped)
#   pypi:<package>     latest release on PyPI
#   go                 current stable Go toolchain
#   k8s                current stable Kubernetes release
TOOLS="
GO_VERSION|go|go
TREE_SITTER_VERSION|tree-sitter|gh:tree-sitter/tree-sitter
KUBECTL_VERSION|kubectl|k8s
KIND_VERSION|kind|gh:kubernetes-sigs/kind
FLUX_VERSION|flux|gh:fluxcd/flux2
GOSS_VERSION|goss|gh:goss-org/goss
CST_VERSION|container-structure-test|gh:GoogleContainerTools/container-structure-test
AGE_VERSION|age|gh:FiloSottile/age
SOPS_VERSION|sops|gh:getsops/sops
ANSIBLE_VERSION|ansible|pypi:ansible
MOLECULE_VERSION|molecule|pypi:molecule
"

# The value currently pinned in docker-bake.hcl.
pinned_version() {
  sed -n "s/^variable \"$1\" *{ *default *= *\"\([^\"]*\)\".*/\1/p" "$BAKE"
}

# The newest version upstream offers, per the source spec.
latest_version() {
  case "$1" in
  gh:*)
    # /releases/latest redirects to /releases/tag/<tag>; no API rate limit.
    curl -fsSL -o /dev/null -w '%{url_effective}' \
      "https://github.com/${1#gh:}/releases/latest" | sed 's|.*/tag/v\?||'
    ;;
  pypi:*)
    curl -fsS "https://pypi.org/pypi/${1#pypi:}/json" \
      | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4
    ;;
  go) curl -fsS 'https://go.dev/VERSION?m=text' | head -1 | sed 's/^go//' ;;
  k8s) curl -fsS https://dl.k8s.io/release/stable.txt | sed 's/^v//' ;;
  *)
    echo "unknown source: $1" >&2
    return 1
    ;;
  esac
}

# Pin a new version. The Dockerfiles declare these as bare ARGs, so this is the
# only place a version is written.
set_version() {
  sed -i "s|^\(variable \"$1\" *{ *default *= *\"\)[^\"]*\(\".*\)|\1$2\2|" "$BAKE"
}

outdated=0
failed=0
checked=0

for entry in $TOOLS; do
  IFS='|' read -r var name source <<<"$entry"

  old=$(pinned_version "$var")
  if [ -z "$old" ]; then
    echo "$name: no \"$var\" variable in $BAKE" >&2
    failed=$((failed + 1))
    continue
  fi

  if ! new=$(latest_version "$source") || [ -z "$new" ]; then
    echo "$name: $old -> ? (lookup failed)" >&2
    failed=$((failed + 1))
    continue
  fi

  checked=$((checked + 1))
  [ "$old" = "$new" ] && continue

  echo "$name: $old -> $new"
  outdated=$((outdated + 1))
  $WRITE && set_version "$var" "$new"
done

if [ "$outdated" -eq 0 ]; then
  echo "all $checked pinned versions are up to date"
elif $WRITE; then
  echo "updated $outdated of $checked pins in $BAKE"
else
  echo "$outdated of $checked pins outdated; run 'make bump-versions' to apply"
fi

[ "$failed" -eq 0 ] || exit 1
