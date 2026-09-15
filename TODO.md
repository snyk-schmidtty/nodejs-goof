# TODO

## Open

### CI / Workflows
- [ ] Verify all workflows pass on `master` after PR #202 actions-bump. CI was `UNSTABLE` at merge (pending checks, not conflicts). Check runs at https://github.com/snyk-schmidtty/nodejs-goof/actions and fix any that still fail. _flagged 2026-08-11_
- [ ] Consider bumping `snyk/actions@0.3.0` in [.github/workflows/snyk.yml](.github/workflows/snyk.yml) — flagged during PR #202 but left alone. Confirm whether floating to a newer tag is desired (this pin is likely legacy, distinct from the intentional `snyk/actions/*@master` demo pins). _flagged 2026-08-11_

### Claude / Memory Setup
- [ ] Restart Claude Code so `autoMemoryDirectory: "memory"` in [.claude/settings.local.json](.claude/settings.local.json) takes effect for future sessions. _flagged 2026-08-11_
- [ ] If `.claude/settings.local.json` should travel with the repo across machines, add `!.claude/settings.local.json` to [.gitignore](.gitignore) — user's global gitignore (`~/.config/git/ignore`) currently blocks it, so it's not committed today. _flagged 2026-08-11_
