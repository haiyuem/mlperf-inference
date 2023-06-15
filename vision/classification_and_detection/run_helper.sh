#!/bin/bash

echo "Clearing caches."
sync && echo 3 | tee /host_proc/sys/vm/drop_caches


cd /root

common_opt=""

start_fmt=$(date +%Y-%m-%d\ %r)
echo "STARTING RUN AT $start_fmt"

cd /mlperf
# -s 2000000000
# /pinroot/pin -t /pinroot/source/tools/readMemVal/obj-intel64/write_load_addr_val.so -o /output/csv2 -i 10000000 -j 90000000 -- python python/main.py $opts --output /output
/pinroot/pin -t /pinroot/source/tools/readMemVal/obj-intel64/proccount.so -o rtnprint.out -- python python/main.py $opts --output /output
# /pinroot/pin -t /pinroot/source/tools/ManualExamples/obj-intel64/inscount0.so -o /output/inscount0 -- python python/main.py $opts --output /output

end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING RUN AT $end_fmt"
