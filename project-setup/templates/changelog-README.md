# Change records

One file per pull request, written by the agent (or person) who made the change, inside that PR.
Each record holds everything a future agent needs about the change: context, what changed,
decisions and rejected alternatives, assumptions, interfaces, verification, limitations, risks,
and notes for whoever touches this area next. Template: `_TEMPLATE.md`.

**Before changing an area, read the records that touched it:**
`grep -l "<path or ID>" docs/changelog/*.md` (front matter lists `areas` and `ids`).

File name: `YYYY-MM-DD-pr-<number>-<slug>.md`. Demo GIFs and screenshots: `assets/<file name without .md>/`.
Release summaries live in `CHANGELOG.md` and link here.

## Index (newest first)

| Date | PR | Change | Issues |
|---|---|---|---|
