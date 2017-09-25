[![Build Status](https://ci.centos.org/buildStatus/icon?job=devtools-fabric8-analytics-scaler-f8a-build-master)](https://ci.centos.org/job/devtools-fabric8-analytics-scaler-f8a-build-master/)

# fabric8-analytics-worker-scaler
Openshift service that scales fabric8 analytics workers based on SQS queue size.
scale.sh is run periodically every minute for now.

### Checking SQS queue for messages

Python script sqs_status accepts one parameter which is queue name

`$ sqs_status.py -q $SQS_QUEUE_FOR_SCALING`

### Configure maximum and minimum number of pods for scaling

`$ export WORKER_POD_TO_SCALE=bayesian-worker-api`

`$ export SQS_QUEUE_FOR_SCALING=prod_ingestion_InitAnalysisFlow_v0`

`$ export DEFAULT_NUMBER_OF_PODS=2`

`$ export MAX_NUMBER_OF_PODS=10`

### Deployment on openshift

Openshift deployment information is located at [openshift](https://github.com/fabric8-analytics/fabric8-analytics-scaler/tree/master/openshift) directory
