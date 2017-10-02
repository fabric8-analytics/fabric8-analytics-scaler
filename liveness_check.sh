#!/bin/bash

set -ex

curr_value=$(cat /var/lib/f8a-scaler/liveness)
prev_value=$(cat /var/lib/f8a-scaler/liveness_prev)

[[ $curr_value -gt $prev_value ]] && echo -n $curr_value > /var/lib/f8a-scaler/liveness_prev
