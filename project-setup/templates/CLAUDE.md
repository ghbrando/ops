# <Project name>

<One or two sentences: what the app is and who uses it.>

## Run and test
- Run: `<command>`
- Test: `<command>`
- Lint / types: `<command, or "none">`
Every change passes these before a PR.

## Sources of truth
- Behavior and IDs: `<design doc path>`
- Structure and rules to preserve: `docs/ARCHITECTURE.md`
- Domain, privacy and safety rules: `docs/POLICY.md`
- Direction: `docs/ROADMAP.md`
- Task work: the GitHub Issue you were given. Work only on Issues with Human Review = Reviewed
  and Status = Ready. The Issue's acceptance criteria define done.

## Workflow
- Branches: `feature/<issue>-<slug>` from `dev` → PR into `dev`. Never push to or approve
  `staging` or `main`.
- Reference the Issue and design IDs in commits and the PR.
- Active work: `docs/current_feature_plans/`.
- Change records: `docs/changelog/` (one per PR). Before changing an area, read the records
  that touched it (`grep -l "<path or ID>" docs/changelog/*.md`); every PR adds its own record.

## Stop and ask the owner
<Project-specific: open decisions, schema changes, security/privacy, anything in POLICY.md marked owner-only.>
