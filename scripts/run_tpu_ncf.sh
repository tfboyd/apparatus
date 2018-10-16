#!/bin/bash

set -e



# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)

export PYTHONPATH=models/:$PYTHONPATH

source /tmp/tpu_ncf_env/bin/activate

python ncf_main.py --data_dir $MLP_PATH_GCS_NCF --learning_rate 0.00136794 --beta1 0.781076 --beta2 0.977589 --epsilon 7.36321e-8  --model_dir $MLP_GCS_MODEL_DIR --tpu $MLP_TPU_NAME

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"



# report result 
result=$(( $end - $start )) 
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

