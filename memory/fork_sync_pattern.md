---
name: fork-sync-pattern
description: Gotcha when fixing merge conflicts on "sync-fork" PRs in this repo
metadata:
  type: project
---

GitHub's "Sync fork" button sometimes opens a PR whose **head is on `snyk-labs/nodejs-goof`** (upstream), not on `snyk-schmidtty/nodejs-goof`. When that PR has conflicts, you can't push fixes — you don't own the head.

**Why:** Discovered during the PR #183 → #201 episode (2026-05-27). The head was `snyk-labs:main`, base was `snyk-schmidtty:master`. Local conflict resolution had to be re-pushed as a *new* PR from a fork-owned branch.

**How to apply:** Before resolving conflicts on a sync-fork PR, check `gh api repos/snyk-schmidtty/nodejs-goof/pulls/<N> --jq '.head.repo.full_name'`. If it's `snyk-labs/...`, the right workflow is: merge upstream locally, push the merge commit to a branch on `snyk-schmidtty`, close the original PR, open a new PR from that branch → master.

Also note: pushing to files under `.github/workflows/` requires the OAuth token to have the `workflow` scope. If `git push` fails with "refusing to allow an OAuth App to create or update workflow", run `gh auth setup-git` to refresh the credential helper (the `gh` token already has the scope, but the git helper may be using an older cached cred).

**Never use `gh pr create` from this fork.** It has a default-to-parent behavior that can silently file the PR against `snyk-labs/nodejs-goof` (upstream) even when `--repo snyk-schmidtty/nodejs-goof` is passed — `--repo` only controls metadata lookup, not the PR target. This caused stray upstream PR #1607 on 2026-05-27. Always create PRs with the target repo spelled out in the URL:

```bash
gh api -X POST repos/snyk-schmidtty/nodejs-goof/pulls \
  -f title="..." -f head="branch-name" -f base="master" -f body="..."
```

Same caution for any `gh` subcommand that auto-detects a parent on forks (`gh pr merge` with cross-repo head, `gh repo sync`, etc.) — always pass explicit `-R snyk-schmidtty/nodejs-goof` and verify the response targets the fork before moving on. **Changes from this repo must never be pushed or PR'd to `snyk-labs`.**
