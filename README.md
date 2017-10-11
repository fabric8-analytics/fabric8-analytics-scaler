[![Build Status](https://ci.centos.org/buildStatus/icon?job=devtools-fabric8-analytics-scaler-f8a-build-master)](https://ci.centos.org/job/devtools-fabric8-analytics-scaler-f8a-build-master/)


# fabric8-analytics-worker-scaler
OpenShift service that scales fabric8-analytics workers based on number of messages in SQS.
This service uses oc-clients package, command oc scale is used to scale the deployment.
This requires to have mounted service account inside the container.
We are using workerscaler service account for that. Definitions and role binding  are available in openshift dir.

### Checking SQS queue for messages

Python script `sqs_status.py` accepts one parameter which is queue name

`$ ./sqs_status.py -q $SQS_QUEUE_NAME`

### Configure maximum and minimum number of pods for scaling

`$ export DC_NAME=bayesian-worker-api`

`$ export SQS_QUEUE_NAME=ingestion_InitAnalysisFlow_v0`

`$ export DEFAULT_REPLICAS=5`

`$ export MAX_REPLICAS=30`

### Deployment on openshift

OpenShift deployment information is located at [openshift](openshift/) directory.
