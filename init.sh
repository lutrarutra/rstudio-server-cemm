#!/bin/bash

echo "OMP Threads: $OMP_NUM_THREADS"

  rserver \
    --www-address=$(hostname).int.cemm.at \
    --www-port=$PORT \
    --rsession-which-r=${RSTUDIO_WHICH_R} \
    --rsession-ld-library-path=${CONDA_PREFIX}/lib \
    --auth-timeout-minutes=0 --auth-stay-signed-in-days=30  \
    --auth-none=0  --auth-pam-helper-path=pam-helper \
    --server-user=${USER}

