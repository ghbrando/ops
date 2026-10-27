#!/usr/bin/env python3
"""Turn a project's docs/issues.json into GitHub Issues on its Project (operating model / Lab 3).

Every Issue gets the standard sections, the `ai-generated` label, and Project fields:
Status (Backlog, or Done in Dev for already-built work), Human Review = Pending, Phase,
Priority, Area, Sequence. Built work is closed with its evidence. The owner reviews each
Issue and moves it to Human Review = Reviewed and Status = Ready.

Safe to re-run: an Issue whose title starts with its [key] is skipped.
Usage: issues.py owner/repo PROJECT_NUMBER [path/to/issues.json] [--dry-run]
"""
import json
import subprocess
import sys

SECTIONS = [
    ("context", "Context"),
    ("trace", "Traceability"),
    ("acceptance", "Acceptance criteria"),
    ("design", "Design references"),
    ("dependencies", "Dependencies / constraints"),
    ("verification", "Verification"),
    ("out_of_scope", "Out of scope"),
    ("evidence", "Completion evidence"),
]
LABEL_COLORS = {"ai-generated": "8250df", "blocked": "d73a4a", "human-action": "fbca04"}


def gh(*args, input=None):
    out = subprocess.run(["gh", *args], input=input, capture_output=True, text=True)
    if out.returncode:
        raise SystemExit(f"gh {' '.join(args[:3])} failed: {out.stderr.strip()}")
    return out.stdout.strip()


def body_for(issue, spec):
    parts = []
    for key, heading in SECTIONS:
        val = issue.get(key)
        if not val:
            continue
        if isinstance(val, list):
            bullet = "- [ ] " if key == "acceptance" and not issue.get("done") else "- "
            val = "\n".join(bullet + v for v in val)
        parts.append(f"## {heading}\n{val}")
    parts.append(
        f"---\nPlan: `{spec.get('plan', '')}` · Source design: `{spec.get('sdd', '')}` · "
        f"Plan item **{issue['key']}**\n\n"
        "_Drafted by an AI agent from the implementation plan. Human Review starts at "
        "**Pending**; an agent may start this Issue only after the owner sets Human Review = "
        "Reviewed and Status = Ready._"
    )
    return "\n\n".join(parts)


def main():
    args = [a for a in sys.argv[1:] if a != "--dry-run"]
    dry = "--dry-run" in sys.argv
    repo, number = args[0], args[1]
    owner = repo.split("/")[0]
    spec = json.load(open(args[2] if len(args) > 2 else "docs/issues.json"))
    issues = sorted(spec["issues"], key=lambda i: i.get("sequence", 999))

    if dry:
        for i in issues:
            print(f"[{i['key']}] {i['title']}  ({'done' if i.get('done') else 'open'})")
            print(body_for(i, spec)[:400], "\n...\n")
        return

    labels = {l for i in issues for l in i.get("labels", [])} | {"ai-generated"}
    for l in sorted(labels):
        gh("label", "create", l, "--repo", repo, "--force", "--color", LABEL_COLORS.get(l, "ededed"))

    project = json.loads(gh("project", "view", number, "--owner", owner, "--format", "json"))
    fields = json.loads(gh("project", "field-list", number, "--owner", owner, "--format", "json"))["fields"]
    fid = {f["name"]: f for f in fields}

    def set_field(item, name, value):
        f = fid[name]
        if "options" in f:
            opt = next((o["id"] for o in f["options"] if o["name"] == value), None)
            if not opt:
                raise SystemExit(f"field {name} has no option {value!r}")
            extra = ["--single-select-option-id", opt]
        else:
            extra = ["--number", str(value)]
        gh("project", "item-edit", "--id", item, "--project-id", project["id"], "--field-id", f["id"], *extra)

    existing = json.loads(gh("issue", "list", "--repo", repo, "--state", "all", "--limit", "500", "--json", "number,title"))
    for i in issues:
        title = f"[{i['key']}] {i['title']}"
        if any(e["title"].startswith(f"[{i['key']}]") for e in existing):
            print(f"{i['key']}: exists, skipped")
            continue
        url = gh("issue", "create", "--repo", repo, "--title", title, "--body-file", "-",
                 *[x for l in ["ai-generated", *i.get("labels", [])] for x in ("--label", l)],
                 input=body_for(i, spec))
        item = json.loads(gh("project", "item-add", number, "--owner", owner, "--url", url, "--format", "json"))["id"]
        set_field(item, "Status", "Done in Dev" if i.get("done") else "Backlog")
        set_field(item, "Human Review", "Pending")
        for name in ("Phase", "Priority", "Area"):
            if i.get(name.lower()):
                set_field(item, name, i[name.lower()])
        if "sequence" in i:
            set_field(item, "Sequence", i["sequence"])
        if i.get("done"):
            gh("issue", "close", url, "--reason", "completed", "--comment",
               "Completed before this backlog was created; see Completion evidence above. "
               "Kept for SDD traceability.")
        print(f"{i['key']}: {url}")


if __name__ == "__main__":
    main()
