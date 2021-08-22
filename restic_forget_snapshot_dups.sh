#!/bin/bash

FORGET_IDS=()

collectSnapshotDupes() {
  echo "---------------------------------------------------------------------------------------------"
  echo "List restic snapshots. Search for identical snapshot-dups"

  local x prevTree

  while read x; do
    local columns=($x)
    local path=${columns[0]}
    local timestamo=${columns[1]}
    local id=${columns[2]}
    local tree=${columns[3]}
    printf "$path ID: $id Tree: $tree" 
    if [ "$tree" == "$prevTree" ]; then
      printf " --> Dupe, will forget $id"
      FORGET_IDS+=($id)
    fi
    printf "\n"
    prevTree=$tree
  done < <(restic snapshots --json|jq '.[]|.paths[0]+" "+.time+" "+.short_id+" "+.tree' -r|sort)
}

collectSnapshotDupes

echo "============================================================================================="
if [ ${#FORGET_IDS[@]} -eq 0 ]; then
  echo "Nothing to forget"
else
  echo "About to forget IDs: restic forget -vvv ${FORGET_IDS[@]}"
  #restic forget -vvv ${FORGET_IDS[@]}
fi

