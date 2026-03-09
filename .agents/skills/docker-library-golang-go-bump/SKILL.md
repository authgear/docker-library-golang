---
name: docker-library-golang-go-bump
description: Update docker-library-golang to a target Go patch release (for example 1.25.8) using the team's branch/cherry-pick/update.sh workflow. Use when a user asks to bump Go image versions in this repo, create a date-named branch from docker/master, cherry-pick existing local commits except the most recent generated commit, run ./update.sh in a GNU-coreutils-compatible Linux shell, and commit the generated changes.
---

# Docker Library Golang Go Bump

Follow this workflow exactly for release bumps.

## Inputs

Require these inputs before running commands:
- target Go version (example: `1.25.8`)
- upstream remote (default: `docker`)
- local work branch whose commits should be ported (default: current branch)

## Workflow

1. Verify clean understanding of commit policy:
- Cherry-pick existing commits from local branch onto fresh branch from `docker/master`.
- Exclude the latest commit from the local branch.
- Latest commit is typically the generated `Run ./update.sh` commit.

2. Fetch upstream and create a branch named with today in `YYYY-MM-DD`:

```bash
git fetch docker
git checkout -b "$(date +%F)" docker/master
```

3. Compute cherry-picks from previous branch, excluding the last commit:

```bash
.codex/skills/docker-library-golang-go-bump/scripts/cherry-picks-except-last.sh
```

4. Cherry-pick each returned commit in order:

```bash
git cherry-pick <commit_1>
git cherry-pick <commit_2>
# ...
```

5. Ensure Linux/GNU coreutils environment before generating files:
- Preferred on Nix: `nix shell nixpkgs#coreutils`
- Alternative via container:

```bash
docker run --rm -it -v "$(pwd):/app" -w /app ubuntu bash
apt update && apt install -y jq gawk wget
./update.sh
```

6. If running locally with correct GNU tools, generate and commit:

```bash
./update.sh
git add .
git commit -m "Run ./update.sh"
```

## Guardrails

- Never cherry-pick the most recent commit from the source branch.
- Resolve conflicts during cherry-picks before continuing.
- Keep branch name date-based (`YYYY-MM-DD`) for this workflow.
- If `update.sh` output differs by environment, rerun from Linux shell with GNU coreutils.

## References

Read [references/checklist.md](references/checklist.md) for a concise runbook and verification checklist.
