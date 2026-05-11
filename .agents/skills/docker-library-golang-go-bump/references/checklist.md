# Go Bump Checklist (docker-library-golang)

## Quick Runbook

1. Confirm target version (example `1.25.8`).
2. `git fetch docker`
3. `git checkout -b "$(date +%F)" docker/master`
4. Generate commit list excluding generated `Run ./update.sh` commits from previous branch:
   ```bash
   source_branch="<source-branch>"
   git rev-list --reverse docker/master.."$source_branch" | while read commit; do
     if [ "$(git show -s --format=%s "$commit")" != "Run ./update.sh" ]; then
       echo "$commit"
     fi
   done
   ```
5. Cherry-pick listed commits in order.
6. Run `./update.sh` in Linux + GNU coreutils environment.
7. `git add . && git commit -m "Run ./update.sh"`

## Verification

- Branch name matches today's date.
- Cherry-picked commit list does not include commits with subject `Run ./update.sh`.
- `versions.json` includes intended target patch version changes.
- Generated Dockerfiles and metadata are updated consistently.
- Final commit message is `Run ./update.sh`.
