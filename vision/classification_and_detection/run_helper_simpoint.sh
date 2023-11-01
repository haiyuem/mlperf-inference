#!/bin/bash

echo "Clearing caches."
sync && echo 3 | tee /host_proc/sys/vm/drop_caches

common_opt=""

start_fmt=$(date +%Y-%m-%d\ %r)
echo "STARTING RUN AT $start_fmt"

# cd /mlperf
# simpoint must be run from output dir
cd /output_simpoint
$RUN_COMMAND 

end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING RUN AT $end_fmt"
