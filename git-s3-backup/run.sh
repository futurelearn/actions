#!/bin/bash
set -eou pipefail

DATE=$(date +%F)
FILENAME="$GITHUB_REPOSITORY/$DATE.tgz"

git archive --format=tar HEAD | gzip > "$FILENAME"
aws s3 cp "$FILENAME" "s3://$S3_BUCKET/$S3_PREFIX/$FILENAME"
