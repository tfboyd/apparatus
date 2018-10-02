#!/bin/bash

set -e


cd staging/models/rough/nmt/

sudo pip3 install tf-nightly

# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)


ls


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

