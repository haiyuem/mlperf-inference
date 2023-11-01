#!/bin/bash

DATA_DIR=$PWD/fake_imagenet_same
MODEL_DIR=$PWD
EXTRA_OPS="--time 3 --max-latency 0.2"
SRC_DIR=$PWD

source ./run_common.sh

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
# cp ../../mlperf.conf .

if [ -z "$global_output_dir" ]; then
    global_output_dir="$PWD/output"
fi
OUTPUT_DIR=$global_output_dir/mlperf/imgclassify/$name/2_gen_trace
OUTPUT_DIR_mlperfresults=${OUTPUT_DIR}/mlperf_results
if [ ! -d $OUTPUT_DIR_mlperfresults ]; then
    mkdir -p $OUTPUT_DIR_mlperfresults
fi

image=mlperf-infer-imgclassify-$device
opts="--mlperf_conf $PWD/mlperf.conf --user_conf $PWD/user.conf --profile $profile $common_opt --model $model_path \
    --dataset-path $DATA_DIR --output $OUTPUT_DIR_mlperfresults $extra_args $EXTRA_OPS $@"

# docker run $gpus -e opts="$opts" \
#     -v $DATA_DIR:$DATA_DIR -v $MODEL_DIR:$MODEL_DIR -v `pwd`:/mlperf \
#     -v $OUTPUT_DIR:/output -v /proc:/host_proc \
#     -t $image:latest /mlperf/run_helper.sh 2>&1 | tee $OUTPUT_DIR/output.txt

singularity exec --env opts="$opts" --bind $PIN_ROOT:/pinroot,$DATA_DIR:$DATA_DIR,$MODEL_DIR:$MODEL_DIR,$SRC_DIR:/mlperf,$OUTPUT_DIR:/output,/proc:/host_proc \
$SRC_DIR/${image}.sif \
/mlperf/run_helper.sh 2>&1