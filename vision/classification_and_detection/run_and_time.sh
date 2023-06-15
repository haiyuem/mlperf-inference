#!/bin/bash

source run_common.sh

DATA_DIR=/scratch/gpfs/hm2595/mlperf/mlperf-inference/vision/classification_and_detection/fake_imagenet
MODEL_DIR=/scratch/gpfs/hm2595/mlperf/mlperf-inference/vision/classification_and_detection
EXTRA_OPS="--time 3 --max-latency 0.2"

# Remove GPU stuff because Singularity handles them differently, and I don't use GPUs for now

# dockercmd=docker
# if [ $device == "gpu" ]; then
#     version=$(docker version -f "{{.Server.Version}}")
#     major_version=$(echo "$version"| cut -d'.' -f 1)
#     minor_version=$(echo "$version"| cut -d'.' -f 2)
#     if [ $major_version -gt 19 ]; then
#         gpus="--gpus all"
#     elif [ $major_version -ge 19 ] && \
#         [ $minor_version -ge 03 ]; then
#         gpus="--gpus all"
#     else
#         gpus="--runtime=nvidia"
#     fi
# fi

# copy the config to cwd so the docker contrainer has access
cp ../../mlperf.conf .

OUTPUT_DIR=/scratch/gpfs/hm2595/mlperf/output/$name
if [ ! -d $OUTPUT_DIR ]; then
    mkdir -p $OUTPUT_DIR
fi

image=mlperf-infer-imgclassify-$device
# docker build  -t $image -f Dockerfile.$device .

# singularity build /scratch/gpfs/hm2595/mlperf/${image}.sif docker-archive:///scratch/gpfs/hm2595/mlperf/${image}_dockerimage.tar

opts="--mlperf_conf ./mlperf.conf --profile $profile $common_opt --model $model_path \
    --dataset-path $DATA_DIR --output $OUTPUT_DIR $extra_args $EXTRA_OPS $@"

# docker run $gpus -e opts="$opts" \
#     -v $DATA_DIR:$DATA_DIR -v $MODEL_DIR:$MODEL_DIR -v `pwd`:/mlperf \
#     -v $OUTPUT_DIR:/output -v /proc:/host_proc \
#     -t $image:latest /mlperf/run_helper.sh 2>&1 | tee $OUTPUT_DIR/output.txt

singularity exec --env opts="$opts" --bind $PIN_ROOT:/pinroot,$DATA_DIR:$DATA_DIR,$MODEL_DIR:$MODEL_DIR,`pwd`:/mlperf,$OUTPUT_DIR:/output,/proc:/host_proc \
${image}.sif \
/mlperf/run_helper.sh 2>&1


#| tee $OUTPUT_DIR/output.txt
