#!/usr/bin/env bash
set -euo pipefail

# Print commit SHAs from source branch that are not on docker/master,
# excluding the latest commit on source branch.
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

# Bash 3 compatible line counting and iteration (no mapfile/readarray).
commit_count="$(printf '%s\n' "$commits_raw" | wc -l | awk '{print $1}')"

if [ "$commit_count" -eq 1 ]; then
  echo "only one commit exists and must be excluded by policy; nothing to cherry-pick" >&2
  exit 0
fi

# Exclude the last (most recent) commit.
printf '%s\n' "$commits_raw" | head -n "$((commit_count - 1))"
