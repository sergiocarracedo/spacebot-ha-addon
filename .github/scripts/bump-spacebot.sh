#!/usr/bin/env bash

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
build_yaml="$repo_root/spacebot/build.yaml"
config_yaml="$repo_root/spacebot/config.yaml"
changelog_md="$repo_root/spacebot/CHANGELOG.md"
release_json="$(mktemp)"
cleanup() {
  rm -f "$release_json"
}
trap cleanup EXIT

require_file() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    printf 'Missing required file: %s\n' "$file" >&2
    exit 1
  fi
}

require_file "$build_yaml"
require_file "$config_yaml"
require_file "$changelog_md"

curl -fsSL \
  -H 'Accept: application/vnd.github+json' \
  -H 'X-GitHub-Api-Version: 2022-11-28' \
  'https://api.github.com/repos/spacedriveapp/spacebot/releases?per_page=20' \
  -o "$release_json"

latest_tag="$(jq -r '.[] | select(.draft == false and .prerelease == false) | .tag_name' "$release_json" | head -n 1 || true)"

if [[ -z "$latest_tag" || "$latest_tag" == "null" ]]; then
  printf 'Unable to determine latest stable upstream release.\n' >&2
  exit 1
fi

current_tag="$(grep -E '^  amd64: ghcr\.io/spacedriveapp/spacebot:' "$build_yaml" | sed -E 's|^  amd64: ghcr\.io/spacedriveapp/spacebot:||' || true)"

if [[ -z "$current_tag" ]]; then
  printf 'Unable to determine current pinned Spacebot version.\n' >&2
  exit 1
fi

if [[ "$current_tag" == "$latest_tag" ]]; then
  printf 'No update needed. Current version is already %s.\n' "$current_tag"
  exit 0
fi

version_without_v="${latest_tag#v}"
release_url="https://github.com/spacedriveapp/spacebot/releases/tag/${latest_tag}"

sed -i -E "s|^(  aarch64: ghcr\.io/spacedriveapp/spacebot:).*$|\\1${latest_tag}|" "$build_yaml"
sed -i -E "s|^(  amd64: ghcr\.io/spacedriveapp/spacebot:).*$|\\1${latest_tag}|" "$build_yaml"
sed -i -E "s|^(version: ').*(')$|\\1${latest_tag}\\2|" "$config_yaml"

if ! grep -Fq "## ${version_without_v}" "$changelog_md"; then
  changelog_tmp="$(mktemp)"
  {
    printf '# Changelog\n\n'
    printf '## %s\n\n' "$version_without_v"
    printf -- '- Uses spacebot [%s](%s) release\n\n' "$version_without_v" "$release_url"
    tail -n +3 "$changelog_md"
  } > "$changelog_tmp"
  mv "$changelog_tmp" "$changelog_md"
fi

printf 'Updated Spacebot from %s to %s.\n' "$current_tag" "$latest_tag"
