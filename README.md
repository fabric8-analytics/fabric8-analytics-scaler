[![Build Status](https://ci.centos.org/buildStatus/icon?job=devtools-fabric8-analytics-scaler-f8a-build-master)](https://ci.centos.org/job/devtools-fabric8-analytics-scaler-f8a-build-master/)

# fabric8-analytics-worker-scaler
OpenShift service that scales fabric8-analytics workers based on number of messages in SQS.

### Checking SQS queue for messages

Python script `sqs_status.py` accepts one parameter which is queue name

`$ ./sqs_status.py -q $SQS_QUEUE_NAME`

### Configure maximum and minimum number of pods for scaling

`$ export DC_NAME=bayesian-worker-api`

`$ export SQS_QUEUE_NAME=prod_ingestion_InitAnalysisFlow_v0`

`$ export DEFAULT_REPLICAS=2`

`$ export MAX_REPLICAS=10`

### Deployment on openshift

OpenShift deployment information is located at [openshift](openshift/) directory
