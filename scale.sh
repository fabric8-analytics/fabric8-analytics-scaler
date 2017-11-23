#!/usr/bin/bash

set -e

set -x
oc whoami
oc project
set +x

queue_name=${DEPLOYMENT_PREFIX}_${SQS_QUEUE_NAME}

while true; do
    # get number of messages in the given queue
    read msg_count replicas <<< $(./sqs_status.py -q ${queue_name})

    echo "[$(date -u)] Number of messages in ${queue_name} is ${msg_count}. Replicas needed: ${replicas}."
    set -x
    oc -n $OC_PROJECT scale --replicas=${replicas} dc $DC_NAME
    set +x

    date -u +%s > /var/lib/f8a-scaler/liveness
    sleep 5m
done
