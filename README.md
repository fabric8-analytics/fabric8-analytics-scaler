# fabric8-analytics-worker-scaler
Openshift service that scales fabric8 analytics workers based on SQS queue size.
scale.sh is run periodically every minute for now.

### Checking SQS queue for messages

Python script sqs_status accepts one parameter which is queue name

`$sqs_status.py -q $SQS_QUEUE_FOR_SCALING`

### Configure maximum and minimum number of pods for scaling

`$export WORKER_POD_TO_SCALE=bayesian-worker-api `
`$export DEFAULT_NUMBER_OF_PODS=2`
`$export MAX_NUMBER_OF_PODS=10`
