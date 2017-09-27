#!/usr/bin/bash -e

set -x
oc whoami
oc project
set +x

DC_NAME="bayesian-worker-ingestion"
SQS_QUEUE_NAME="stage_ingestion_bayesianAnalysisFlow_v0"

DEFAULT_REPLICAS=5
MAX_REPLICAS=10


function oc_process_apply() {
  echo -e "\n Processing template - $1 ($2) \n"
  oc process -f $1 $2 | oc apply -f -
}

here=`dirname $0`
template="${here}/template.yaml"

oc_process_apply "$template" "-p DC_NAME=${DC_NAME} -p ${SQS_QUEUE_NAME} -p ${DEFAULT_REPLICAS} -p ${MAX_REPLICAS}"
