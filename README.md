# ops

Owner-only automation. **New project** (Actions tab → New project → Run workflow) creates a
governed repo: scaffold, dev/staging rulesets, Project board, `brandondevbot` write access.
Every run waits for the owner's approval (environment `owner`) before the owner token is used.
Source of truth for the scripts is `~/.claude`; re-copy here when they change.
