#!/bin/bash
set -eo pipefail

BRANCH_NAME="${GITHUB_REF##*/}"

if [[ -z "$BRANCH_NAME" || -z "$GITHUB_SHA" ]]; then
  echo "BRANCH_NAME and GITHUB_SHA variables must be set."
  exit 1
fi

PASSED_BRANCH="${BRANCH_NAME}-build-passed"
MAX_TRIES=5

function fetch_deploy_branch() {
  git fetch origin "${PASSED_BRANCH}:refs/remotes/origin/${PASSED_BRANCH}" || exit 1
}

function build_commit_not_yet_promoted() {
  fetch_deploy_branch && ! git merge-base --is-ancestor "$GITHUB_SHA" "origin/${PASSED_BRANCH}"
}

function push_force_with_lease() {
  git push --force-with-lease="origin/${PASSED_BRANCH}" origin "${GITHUB_SHA}:${PASSED_BRANCH}"
}

function succeed() {
  echo "${1}"
  exit 0
}

function fail() {
  echo "${1}"
  exit 1
}

for tries in $(seq 0 "${MAX_TRIES}"); do
  [[ "${tries}" -ge "${MAX_TRIES}" ]] && fail "Aborting after ${tries} attempts."

  if build_commit_not_yet_promoted; then
    echo "Commit ${GITHUB_SHA} is not yet in origin/${PASSED_BRANCH} - attempting to push..."

    if push_force_with_lease; then
      succeed "Updated ${PASSED_BRANCH} to ${GITHUB_SHA}."
    else
      echo "Upstream changes detected while pushing - retrying..."
    fi
  else
    succeed "Commit ${GITHUB_SHA} is already in origin/${PASSED_BRANCH} - no action required."
  fi
done
