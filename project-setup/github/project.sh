#!/bin/zsh
# GitHub Project (v2) for the operating model, linked to one repo.
# Fields: Status (board flow), Human Review (Pending/Reviewed), Phase, Priority, Area, Sequence.
# Safe to re-run: reuses a Project with the same title and only adds missing fields.
# Usage: project.sh owner owner/repo "Project title" "Phase A,Phase B,..." ["Area A,Area B,..."]
# Prints the Project number on the last line.
set -e
owner=${1:?owner}; repo=${2:?owner/repo}; title=${3:?title}; phases=${4:?comma-separated phases}
areas=${5:-Frontend,Backend,AI,Infra,Docs}
status_opts=(Backlog Ready "In Progress" "Agent Review" "Done in Dev" "Staging Candidate" Released)

num=$(gh project list --owner $owner --format json --jq ".projects[] | select(.title==\"$title\") | .number" | head -1)
if [[ -z $num ]]; then
  num=$(gh project create --owner $owner --title "$title" --format json --jq .number)
  echo "project: created #$num"
else
  echo "project: exists #$num"
fi
gh project link $num --owner $owner --repo ${repo#*/} >/dev/null 2>&1 || true

fields=$(gh project field-list $num --owner $owner --format json)
has() { print -r -- "$fields" | python3 -c "import json,sys;print(any(f['name']==sys.argv[1] for f in json.load(sys.stdin)['fields']))" "$1" | grep -q True; }
add_select() {  # name, comma-separated options
  if has "$1"; then echo "field $1: exists"; else
    gh project field-create $num --owner $owner --name "$1" --data-type SINGLE_SELECT --single-select-options "$2" >/dev/null
    echo "field $1: created"; fi
}

# The built-in Status field: replace its default options with the operating model's flow.
pid=$(gh project view $num --owner $owner --format json --jq .id)
sid=$(print -r -- "$fields" | python3 -c "import json,sys;print(next(f['id'] for f in json.load(sys.stdin)['fields'] if f['name']=='Status'))")
cur=$(print -r -- "$fields" | python3 -c "import json,sys;print(','.join(o['name'] for f in json.load(sys.stdin)['fields'] if f['name']=='Status' for o in f.get('options',[])))")
want=${(j:,:)status_opts}
if [[ $cur == $want ]]; then echo "field Status: ok"; else
  opts=$(python3 -c "import json,sys;print(json.dumps([{'name':n,'color':'GRAY','description':''} for n in sys.argv[1].split(',')]))" "$want")
  gh api graphql -f query='mutation($f:ID!,$o:[ProjectV2SingleSelectFieldOptionInput!]){updateProjectV2Field(input:{fieldId:$f,singleSelectOptions:$o}){projectV2Field{... on ProjectV2SingleSelectField{name}}}}' \
    -f f=$sid --raw-field o="$opts" >/dev/null 2>&1 \
  || gh api graphql --input - >/dev/null <<EOF
{"query":"mutation(\$f:ID!,\$o:[ProjectV2SingleSelectFieldOptionInput!]){updateProjectV2Field(input:{fieldId:\$f,singleSelectOptions:\$o}){projectV2Field{... on ProjectV2SingleSelectField{name}}}}","variables":{"f":"$sid","o":$opts}}
EOF
  echo "field Status: options set"
fi

add_select "Human Review" "Pending,Reviewed"
add_select "Phase" "$phases"
add_select "Priority" "P0,P1,P2"
add_select "Area" "$areas"
if has Sequence; then echo "field Sequence: exists"; else
  gh project field-create $num --owner $owner --name Sequence --data-type NUMBER >/dev/null; echo "field Sequence: created"; fi
echo $num
