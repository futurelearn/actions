# git-s3-backup

Backs up a Git repository to an Amazon S3 bucket.

## Usage

```
name: Git backup
on:
  schedule:
    - cron:  '0 0 * * *'

jobs:
  backup:
    name: Git backup
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0 # Fetch the full repository
      - uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-west-1 # Set the region of the bucket
      - uses: futurelearn/actions/git-s3-backup@main
        with:
          bucket: my-bucket # required
          prefix: backups # defaults to "current"
```
