#!/bin/bash
set -eo pipefail

NOW_UNIX=$(date +%s)
CREATED_AT_DATE=$(curl -sSH "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}" |jq -r '.created_at')
CREATED_AT_UNIX=$(date -d "${CREATED_AT_DATE}" +%s)
BUILD_DURATION=$(( NOW_UNIX - CREATED_AT_UNIX ))

aws cloudwatch put-metric-data \
  --namespace "${CLOUDWATCH_NAMESPACE}"\
  --dimensions "Repository=${GITHUB_REPOSITORY},Branch=${GITHUB_REF#refs/heads/}"\
  --metric-name "BuildDuration"\
  --value "${BUILD_DURATION}"
