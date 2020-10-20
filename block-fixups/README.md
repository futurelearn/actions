# Block fixups

Checks if a PR has fixup or squash commits. 

## How to use

```
name: Block fixup/squash commits
on:
  push:
    branches-ignore: [ $default-branch ]

jobs:
  block-fixups:
    name: Block fixups
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - uses: futurelearn/actions/block-fixups@main
```
