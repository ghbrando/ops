#!/bin/zsh
# Lab 2 trust boundary for a GitHub repo: feature/* -> dev -> staging -> main.
# Creates dev and staging from main if missing, then applies the two rulesets in ./rulesets:
#   dev-integration  PR-only into dev, no force-push/deletion (agents may merge their own PRs)
#   promotion-gate   PR + 1 approval into staging/main, direct updates blocked; only Admin bypasses
# Safe to re-run: existing branches and rulesets with the same name are left alone.
# Usage: governance.sh owner/repo
set -e
repo=${1:?usage: governance.sh owner/repo}
here=${0:A:h}

main_sha=$(gh api repos/$repo/git/ref/heads/main --jq .object.sha)
for b in dev staging; do
  if gh api repos/$repo/git/ref/heads/$b >/dev/null 2>&1; then
    echo "branch $b: exists"
  else
    gh api repos/$repo/git/refs -f ref=refs/heads/$b -f sha=$main_sha >/dev/null
    echo "branch $b: created from main"
  fi
done

existing=$(gh api repos/$repo/rulesets --jq '.[].name')
for f in $here/rulesets/*.json; do
  name=${f:t:r}
  if print -r -- "$existing" | grep -qx "$name"; then
    echo "ruleset $name: exists"
  else
    gh api -X POST repos/$repo/rulesets --input $f >/dev/null
    echo "ruleset $name: created"
  fi
done
