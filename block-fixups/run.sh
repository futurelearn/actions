#!/bin/bash

#
# Alert when there are fixup or squash commits
#

set -eo pipefail

BRANCH_NAME="${GITHUB_REF##*/}"
if [[ -z "$BRANCH_NAME" || -z "$DEFAULT_BRANCH" ]]; then
  echo "BRANCH_NAME and DEFAULT_BRANCH must be set."
  exit 1
fi

function merge_base() { git merge-base "origin/$DEFAULT_BRANCH" "origin/$BRANCH_NAME"; }

function commit_list() { git log "$(merge_base)".."$BRANCH_NAME"; }

FIXUPS=$(commit_list | grep -c "fixup\!\?" || true)
SQUASHES=$(commit_list | grep -c "squash\!\?" || true)

if [ "$FIXUPS" -gt "0" ] || [ "$SQUASHES" -gt "0" ]; then
  echo ::set-output name=result::"fixup! commits: ${FIXUPS} squash! commits: ${SQUASHES}"
fi


