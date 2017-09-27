# Deploying worker scaler

First make sure you're logged in to the right cluster and on the right project:

```
$ oc project
```

Note this guide assumes that secrets and config maps have already been deployed.

## Configrue worker scaler

Environment variables are used to configure the scaler.

### OpenShift deployment that will be auto scaled
```
$WORKER_POD_TO_SCALE
```

### Name of the SQS queue that will be used as scaling metrics
```
$SQS_QUEUE_FOR_SCALING
```
### Number of pods that are used by default for this deployement
```
$DEFAULT_NUMBER_OF_PODS
```
### Upper limit of pods that we will scale to
```
$MAX_NUMBER_OF_PODS
```


To deploy worker scaler simply run

```
./deploy.sh
```
