# notify

Sends a simple Slack notification for the results of a CI build.

## How to use

```
name: CI
on: push

jobs:
  tests:
    name: Test
    runs-on: ubuntu-latest
    steps:
      ...
      - uses: futurelearn/actions/notify@main
        if: always()
        with:
          webhook: ${{ secrets.SLACK_WEBHOOK }}
          channel: #notifications
```
