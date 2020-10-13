#!/bin/bash
set -eou pipefail

DATE=$(date +%F)
FILENAME="$GITHUB_REPOSITORY/git-bundle-$DATE.gz"
TMPFILE=$(mktemp)

git bundle create - --all |gzip > "$TMPFILE"
aws s3 cp "$TMPFILE" "s3://$S3_BUCKET/$S3_PREFIX/$FILENAME"
