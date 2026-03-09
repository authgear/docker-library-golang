# Go Bump Checklist (docker-library-golang)

## Quick Runbook

1. Confirm target version (example `1.25.8`).
2. `git fetch docker`
3. `git checkout -b "$(date +%F)" docker/master`
4. Generate commit list excluding generated `Run ./update.sh` commits from previous branch:
   - `.agents/skills/docker-library-golang-go-bump/scripts/cherry-picks-except-last.sh <source-branch>`
5. Cherry-pick listed commits in order.
6. Run `./update.sh` in Linux + GNU coreutils environment.
7. `git add . && git commit -m "Run ./update.sh"`

## Verification

- Branch name matches today's date.
- Cherry-picked commit list does not include commits with subject `Run ./update.sh`.
- `versions.json` includes intended target patch version changes.
- Generated Dockerfiles and metadata are updated consistently.
- Final commit message is `Run ./update.sh`.
