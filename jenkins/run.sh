#!/bin/bash
#
# Required environment variables:
# JOB_NAME
# TOKEN
# URL
# USER
#
# Optional environment variables
# PARAMETERS
set -eo pipefail

if [[ -n $PARAMETERS ]]; then
  FORMAT_PARAMETERS=$(echo "$PARAMETERS" | sed 's/^/--data /; s/,/ --data /g')

  CURL_ARGS="${URL}/job/${JOB_NAME}/buildWithParameters --user $USER:$TOKEN $FORMAT_PARAMETERS"
else
  CURL_ARGS="${URL}/job/${JOB_NAME}/build --user $USER:$TOKEN"
fi

RESPONSE=$(curl -sSI "$CURL_ARGS")
STATUS_CODE=$(echo "$RESPONSE" | head -n1 | cut -d" " -f2)

if [[ $STATUS_CODE -ne 201 ]]; then
  echo -e "Failed to trigger job! Response received:\n$RESPONSE"

  exit 1
fi

echo "${JOB_NAME} triggered successfully!"
