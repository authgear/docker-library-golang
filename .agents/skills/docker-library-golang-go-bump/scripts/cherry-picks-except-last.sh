#!/usr/bin/env bash
set -euo pipefail

# Print commit SHAs from source branch that are not on docker/master,
# excluding generated commits with subject "Run ./update.sh".
# Usage:
#   cherry-picks-except-last.sh [source-branch] [upstream-main]
# Defaults:
#   source-branch: current branch
#   upstream-main: docker/master

source_branch="${1:-$(git rev-parse --abbrev-ref HEAD)}"
upstream_main="${2:-docker/master}"

if ! git rev-parse --verify "$source_branch" >/dev/null 2>&1; then
  echo "source branch not found: $source_branch" >&2
  exit 1
fi

if ! git rev-parse --verify "$upstream_main" >/dev/null 2>&1; then
  echo "upstream ref not found: $upstream_main" >&2
  exit 1
fi

commits_raw="$(git rev-list --reverse "${upstream_main}..${source_branch}")"

if [ -z "$commits_raw" ]; then
  echo "no commits to cherry-pick from ${source_branch} onto ${upstream_main}" >&2
  exit 0
fi

selected_count=0
while IFS= read -r commit; do
  [ -z "$commit" ] && continue
  commit_subject="$(git show -s --format=%s "$commit")"
  if [ "$commit_subject" = "Run ./update.sh" ]; then
    continue
  fi
  printf '%s\n' "$commit"
  selected_count="$((selected_count + 1))"
done <<EOF
$commits_raw
EOF

if [ "$selected_count" -eq 0 ]; then
  echo "no non-generated commits to cherry-pick from ${source_branch} onto ${upstream_main}" >&2
fi
