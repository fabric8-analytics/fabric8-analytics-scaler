#!/usr/bin/bash -e

function scale_to_default { 
    oc -n $OC_PROJECT scale --replicas=$DEFAULT_REPLICAS dc $DC_NAME
}

set -x
oc whoami
oc project
set +x
while true; do
    # get number of messages in the given queue
    number_of_messages=$(./sqs_status.py -q ${DEPLOYMENT_PREFIX}_${SQS_QUEUE_NAME})

    echo "Number of messages in queue: $number_of_messages"

    #run scale based on number of messages
    if (( NUMBER_OF_MESSAGES > 10000 )); then
        oc -n $OC_PROJECT scale --replicas=$MAX_REPLICAS dc $DC_NAME

    elif (( NUMBER_OF_MESSAGES < 5000 )); then
        scale_to_default

    elif (( NUMBER_OF_MESSAGES < 1000 )); then
        oc -n $OC_PROJECT scale --replicas=3 dc $DC_NAME

    elif (( NUMBER_OF_MESSAGES < 500 )); then
        oc -n $OC_PROJECT scale --replicas=2 dc $DC_NAME
    fi

    date -u +%s > /var/lib/f8a-scaler/liveness
    sleep 1m
done
