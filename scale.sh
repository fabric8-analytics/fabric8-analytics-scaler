#!/usr/bin/bash -e

function scale_to_default { 
    oc scale --replicas=$DEFAULT_NUMBER_OF_PODS dc $WORKER_POD_TO_SCALE
}

set -x
oc whoami
oc project
set +x

#get number of messages in queue prod_ingestion_bayesianPackageFlow_v0 DEV_livenessFlow_v0
NUMBER_OF_MESSAGES=$(./sqs_status.py -q $SQS_QUEUE_FOR_SCALING)

echo "Number of messages in queue: $NUMBER_OF_MESSAGES"

#run scale based on number of messages
if (( NUMBER_OF_MESSAGES > 10000 )); then
    oc scale --replicas=$MAX_NUMBER_OF_PODS dc $WORKER_POD_TO_SCALE

elif (( NUMBER_OF_MESSAGES < 5000 )); then
    scale_to_default

elif (( NUMBER_OF_MESSAGES < 1000 )); then
    oc scale --replicas=3 dc $WORKER_POD_TO_SCALE

elif (( NUMBER_OF_MESSAGES < 500 )); then
    oc scale --replicas=2 dc $WORKER_POD_TO_SCALE
fi
