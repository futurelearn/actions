# CloudWatch Metrics

Populate CloudWatch with how long your workflows are taking.

```
jobs:
  my_job:
    runs-on: ubuntu-latest
    steps:
    ...

  metrics:
    needs: [ my_job ]
    runs-on: ubuntu-latest
    steps:
    - uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: eu-west-2
    - uses: futurelearn/actions/cloudwatch-metrics@main
      with:
        namespace: MyNamespace # default is GitHubActions
```

The AWS credentials will require permissions to `cloudwatch:PutMetricData`.
