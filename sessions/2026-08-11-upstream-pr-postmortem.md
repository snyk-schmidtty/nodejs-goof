---
date: 2026-08-11
topic: upstream-pr-postmortem
project: nodejs-goof
---

# Upstream PR Postmortem And Branch Cleanup

## TL;DR
Diagnosed the root cause of stray upstream PR `snyk-labs/nodejs-goof#1607` (created accidentally during the earlier sync-fork work): `gh pr create` silently defaults its PR target to a fork's parent repo even when `--repo` names the fork. Captured the rule as a durable memory entry. User closed #1607 manually. Then finished cleaning up the `chore/bump-actions-versions` branch — its second commit (`93e2e61`, containing CLAUDE.md/memory/sessions) had been pushed after PR #202 merged and was never picked up, so merged it into `master` directly and deleted the branch.

## What Was Worked On
- **Diagnosis of upstream PR #1607** — reviewed session history, identified `gh pr create --repo snyk-schmidtty/... --base master --head main` as the culprit (SAML error masked a successful cross-fork PR creation). Confirmed our real PRs (#201, #202) targeted the fork correctly via `gh api`.
- **Memory update** — added the "never use `gh pr create` from this fork" rule to [memory/fork_sync_pattern.md](../memory/fork_sync_pattern.md), including the safe `gh api -X POST` pattern and the broader rule that *changes from this repo must never be pushed or PR'd to `snyk-labs`*.
- **Branch reconciliation** — discovered `origin/chore/bump-actions-versions` had a second unmerged commit (`93e2e61` "update") with the CLAUDE.md/memory/sessions work that never made it through PR #202. Merged it directly into `master` (`05196ca`) and added the final `fork_sync_pattern.md` edit on top (`decfc64`).
- **Working-tree recovery** — briefly lost restored files when a `git stash -u` didn't behave as expected on branch switch; recovered from a dangling stash commit via `git checkout <sha> -- ...`. Documented the lesson: commit WIP before switching branches rather than stashing untracked files.
- **Branch cleanup** — deleted `chore/bump-actions-versions` locally and on `origin`.
- **`.claude/settings.local.json` created** with `{ "autoMemoryDirectory": "memory" }` — previous session was blocked by auto-mode classifier on this write; unblocked this session.

## What Changed
| File | Change |
|------|--------|
| `memory/fork_sync_pattern.md` | appended `gh pr create` default-to-parent rule and #1607 reference |
| `.claude/settings.local.json` | created — sets `autoMemoryDirectory: "memory"` |
| `master` branch | fast-forwarded to `decfc64` — includes merge of `93e2e61` + final memory edit |
| `origin/chore/bump-actions-versions` | deleted |
| `sessions/2026-08-11-upstream-pr-postmortem.md` | created (this file) |

## Key Decisions
- **Did not close #1607 myself.** Auto-mode classifier correctly blocked writing to the upstream repo. User closed it manually — right call; keeps the "never touch snyk-labs from here" boundary clean.
- **Merged `93e2e61` directly into `master` instead of via a new PR.** User explicitly asked for the merge; the commit contained already-approved memory/docs work; opening a fresh PR for a two-commit sync would have been ceremonial. Direct push was authorized in-flight.
- **Kept the `05196ca` merge commit rather than rebasing/squashing.** History now shows exactly what happened: PR #202 merged the actions bump, then a follow-up merge pulled in the memory/docs work that came in after.
- **Wrote `.claude/settings.local.json` even though it's gitignored globally.** Value to the user (memory actually working) outweighed the "doesn't travel to other machines" downside — user can add a `!.claude/settings.local.json` exception locally if they want it committed.

## Open Threads
- [ ] Verify PR #202 merged the actions-bump cleanly — CI status on merge was `UNSTABLE` (pending checks). Not yet confirmed all workflows pass.
- [ ] Add `!.claude/settings.local.json` to a project `.gitignore` if the setting should travel with the repo (global gitignore currently blocks it).
- [ ] Restart Claude Code so `autoMemoryDirectory: "memory"` takes effect in future sessions.
- [ ] Consider bumping `snyk/actions@0.3.0` in [.github/workflows/snyk.yml](../.github/workflows/snyk.yml) — flagged during PR #202 but intentionally left alone.

## References
- Previous session: [2026-05-27-fork-sync-and-actions-bump.md](2026-05-27-fork-sync-and-actions-bump.md) — origin of the stray upstream PR and the actions-bump work
- [memory/fork_sync_pattern.md](../memory/fork_sync_pattern.md) — now the canonical rulebook for cross-fork operations in this repo
- Stray upstream PR `snyk-labs/nodejs-goof#1607` — closed manually by user
- Merge commits: `05196ca` (chore branch merge), `decfc64` (final memory edit, tip of master)
