$device=cpu # could be gpu
image=mlperf-infer-imgclassify-$device
docker build  -t $image -f Dockerfile.$device .