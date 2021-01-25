#!/bin/bash
#
# Notify
#

BRANCH_NAME=$(echo "$GITHUB_REF" |cut -d "/" -f3)
COMMIT_MESSAGE=$(echo "$COMMIT_MESSAGE" | head -n1)

if [[ -n $DEFINED_JOB_STATUS ]]; then
  JOB_STATUS=$DEFINED_JOB_STATUS
fi

case $JOB_STATUS in
  success)
    STATUS=":tada: Succeeded"
    COLOR="good"
    ;;
  failure)
    STATUS=":pouting_cat: Failed"
    COLOR="danger"
    ;;
  cancelled)
    STATUS="Cancelled"
    COLOR="#cddbda"
    ;;
  *)
    STATUS="Unknown"
    COLOR="#cddbda"
    ;;
esac

IFS='' read -r -d '' PAYLOAD <<EOF
{
  "channel": "$SLACK_CHANNEL",
  "attachments": [
    {
      "color": "$COLOR",
      "title": "$GITHUB_REPOSITORY (#$GITHUB_RUN_NUMBER)",
      "title_link": "https://github.com/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID",
      "fields": [
        {
          "title": "Status",
          "value": "$STATUS",
          "short": true
        },
        {
          "title": "Committer",
          "value": "$COMMIT_AUTHOR",
          "short": true
        },
        {
          "title": "Commit",
          "value": "$COMMIT_MESSAGE\n(<https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA|${GITHUB_SHA: -6}> / $BRANCH_NAME)",
          "short": false
        }
      ]
    }
  ]
}
EOF

RESULT=$(curl -s -XPOST -H "Content-Type: application/json" "$SLACK_WEBHOOK" -d "$PAYLOAD")

if [[ $RESULT != "ok" ]]; then
  echo "Error returned by Slack: $RESULT"
  exit 1
fi
