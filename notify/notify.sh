#!/bin/bash
#
# Notify
#

BRANCH_NAME="$(echo "$GITHUB_REF" |cut -d "/" -f3)"

case $JOB_STATUS in
  success) STATUS="Succeeded";;
  failure) STATUS="Failed";;
  cancelled) STATUS="Cancelled";;
esac

IFS='' read -r -d '' PAYLOAD <<EOF
{
  "text": "Test message",
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "<https://github.com/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID|*$GITHUB_REPOSITORY (#$GITHUB_RUN_NUMBER)*>"
      }
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*Status*\n$STATUS"
        },
        {
          "type": "mrkdwn",
          "text": "*Committer*\n$COMMIT_AUTHOR"
        },
        {
        "type": "mrkdwn",
        "text": "*Commit*\n$(echo "$COMMIT_MESSAGE" | head -n1)\n(<https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA|${GITHUB_SHA: -6}> / $BRANCH_NAME)"
        },
      ]
    }
  ]
}
EOF

curl -XPOST -H "Content-Type: application/json" "$SLACK_WEBHOOK" -d "$PAYLOAD"
