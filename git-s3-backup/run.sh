#!/bin/bash
set -eou pipefail

DATE=$(date +%F)
FILENAME="$GITHUB_REPOSITORY/$DATE.tgz"
TMPFILE=$(mktemp)

git archive --format=tar HEAD | gzip > "$TMPFILE"
aws s3 cp "$TMPFILE" "s3://$S3_BUCKET/$S3_PREFIX/$FILENAME"
