#!/bin/bash

REPO_PATH=$(dirname "$0")

source ${REPO_PATH}/.env

NUM_CPUS=$NUM_CPUS \
    MEM_GB=$MEM_GB \
    QUEUE=$QUEUE \
    TIME_LIMIT=$TIME_LIMIT \
    REPO_PATH=$REPO_PATH \
    envsubst '${NUM_CPUS},${MEM_GB},${QUEUE},${TIME_LIMIT},${REPO_PATH}' < ${REPO_PATH}/submit.template.sh > submit.sh

sbatch submit.sh "$@"
# rm -f submit.sh