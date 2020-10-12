#!/bin/bash
#
# Notify
#

BRANCH_NAME="${GITHUB_REF/refs\/head\//}"

IFS='' read -r -d '' PAYLOAD <<EOF
{
  "text": "Test message",
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "<https://github.com/$GITHUB_REPOSITORY/runs/$GITHUB_RUN_ID|$GITHUB_REPOSITORY (#$GITHUB_RUN_NUMBER)>"
      }
    },
    {
      "type": "section",
      "fields": [
        {
        "type": "mrkdwn",
        "text": "*Commit*\n$(echo "$COMMIT_MESSAGE" | head -n1)\n(<https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA|${GITHUB_SHA: -6}> / $BRANCH_NAME)"
        },
        {
          "type": "mrkdwn",
          "text": "*Committer*\n$COMMIT_AUTHOR"
        }
      ]
    }
  ]
}
EOF

curl -XPOST -H "Content-Type: application/json" "$SLACK_WEBHOOK" -d "$PAYLOAD"
