$device=cpu # could be gpu
image=mlperf-infer-imgclassify-$device
singularity build ${image}.sif docker-archive://${image}_dockerimage.tar
