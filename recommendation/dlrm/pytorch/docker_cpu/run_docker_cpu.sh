#!/bin/bash

HOST_MLCOMMONS_ROOT_DIR=/scratch/gpfs/hm2595/mlperf/mlperf-inference    # path to mlcommons/inference
DLRM_DIR=/scratch/gpfs/hm2595/mlperf/mlperf-inference/recommendation                # path to DLRM    
MODEL_DIR=/scratch/gpfs/hm2595/mlperf/mlperf-inference/recommendation/model        # path to model folder
DATA_DIR=/scratch/gpfs/hm2595/mlperf/mlperf-inference/recommendation/dlrm/pytorch/tools/fake_criteo/        # path to data folder

# Using singularity shell for an interactive session
# singularity shell \
singularity shell \
--bind $DLRM_DIR:/root/dlrm \
--bind $MODEL_DIR:/root/model \
--bind $DATA_DIR:/root/data \
--bind $HOST_MLCOMMONS_ROOT_DIR:/root/mlcommons \
--bind /scratch/gpfs/hm2595/mlperf/mlperf-inference/loadgen:/scratch/gpfs/hm2595/mlperf/mlperf-inference/loadgen \
--env DATA_DIR=/root/data \
--env MODEL_DIR=/root/model \
--env DLRM_DIR=/root/dlrm \
dlrm-cpu-localdocker.sif 
