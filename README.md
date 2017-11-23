[![Build Status](https://ci.centos.org/buildStatus/icon?job=devtools-fabric8-analytics-scaler-f8a-build-master)](https://ci.centos.org/job/devtools-fabric8-analytics-scaler-f8a-build-master/)


# fabric8-analytics-worker-scaler
OpenShift service that scales fabric8-analytics workers based on number of messages in SQS.
This service directly uses `oc` command-line tool to scale the deployment.
This requires to have mounted service account inside the container.
`workerscaler` service account for that purpose by default. Definitions and role binding of the service account
are available in the [openshift/](openshift/) directory.


## Configuration

The service needs to be configured via environment variables.
The list of variables recognized by the service follows.

`DC_NAME`

Name of the deployment config to scale. Default value: `bayesian-worker-ingestion`

`DEFAULT_REPLICAS`

Default (minimum) number of replicas. Default value: 5

`MAX_REPLICAS`

Max number of replicas. Default value: 10

`SQS_QUEUE_NAME`

Name of the queue to monitor (without deployment prefix). Default value: `ingestion_bayesianFlow_v0`

`OC_PROJECT`

Name of the project in OpenShift where to apply the changes. Default value: `bayesian-preview`

`SCALE_COEF`

Number of messages that singe worker is able to process, i.e. no need to spawn additional pods.

`SLEEP_INTERVAL`

Interval, in minutes, how often to run the scaler.


The default values can be tweaked directly in the [template](openshift/template.yaml).
The values for specific deployments (staging, production) can be set
in [openshiftio/saas-analytics](https://github.com/openshiftio/saas-analytics/blob/master/bay-services/worker-scaler.yaml) repository.


### Script for checking number of messages in given SQS queue

Python script `sqs_status.py` accepts one parameter which is queue name

`$ ./sqs_status.py -q $SQS_QUEUE_NAME`


### Deployment on openshift

OpenShift deployment information is located at [openshift](openshift/) directory.
