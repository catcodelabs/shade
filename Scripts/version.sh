#!/usr/bin/env bash

SHADE_CLONE_PATH=$(git rev-parse --show-toplevel)
SHADE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
SHADE_REMOTE=$(git config --get remote.origin.url)
SHADE_VERSION=$(git describe --tags --always)
SHADE_COMMIT_HASH=$(git rev-parse HEAD)
SHADE_VERSION_COMMIT_MSG=$(git log -1 --pretty=%B)
SHADE_VERSION_LAST_CHECKED=$(date +%Y-%m-%d\ %H:%M%S\ %z)

generate_release_notes() {
  local latest_tag
  local commits

  latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)

  if [[ -z "$latest_tag" ]]; then
    echo "No release tags found"
    return
  fi

  echo "=== Changes since $latest_tag ==="

  commits=$(git log --oneline --pretty=format:"• %s" "$latest_tag"..HEAD 2>/dev/null)

  if [[ -z "$commits" ]]; then
    echo "No commits since last release"
    return
  fi

  echo "$commits"
}

# SHADE_RELEASE_NOTES=$(generate_release_notes)

echo "shade $SHADE_VERSION built from branch $SHADE_BRANCH at commit ${SHADE_COMMIT_HASH:0:12} ($SHADE_VERSION_COMMIT_MSG)"
echo "Date: $SHADE_VERSION_LAST_CHECKED"
echo "Repository: $SHADE_CLONE_PATH"
echo "Remote: $SHADE_REMOTE"
echo ""

if [[ "$1" == "--cache" ]]; then
  state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/shade"
  mkdir -p "$state_dir"
  version_file="$state_dir/version"

  cat >"$version_file" <<EOL
SHADE_CLONE_PATH='$SHADE_CLONE_PATH'
SHADE_BRANCH='$SHADE_BRANCH'
SHADE_REMOTE='$SHADE_REMOTE'
SHADE_VERSION='$SHADE_VERSION'
SHADE_VERSION_LAST_CHECKED='$SHADE_VERSION_LAST_CHECKED'
SHADE_VERSION_COMMIT_MSG='$SHADE_VERSION_COMMIT_MSG'
SHADE_COMMIT_HASH='$SHADE_COMMIT_HASH'
EOL
# SHADE_RELEASE_NOTES='$SHADE_RELEASE_NOTES'

  echo -e "Version cache output to $version_file\n"

elif [[ "$1" == "--release-notes" ]]; then
  echo "$SHADE_RELEASE_NOTES"

fi
