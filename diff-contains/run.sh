#!/bin/bash

set -e

git fetch origin "$DEFAULT_BRANCH" --depth=1
DIFF=$(git diff -i -S"$SEARCH_TERM" --name-only "origin/$DEFAULT_BRANCH" "$GITHUB_SHA")

export DIFF

RESULT=false
if [[ $DIFF != "" ]]; then
  echo "Discovered $SEARCH_TERM in files:"
  echo -e "$DIFF"

  RESULT=true
fi

echo ::set-output name=result::$RESULT
