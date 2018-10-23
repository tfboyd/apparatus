#!/bin/bash

set -e


# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)

export PYTHONPATH=models/:$PYTHONPATH

source /tmp/tpu_ncf_env/bin/activate

export COMPLIANCE_FILE="compliance_raw.log"
export STITCHED_COMPLIANCE_FILE="compliance_submission.log"
python models/official/recommendation/ncf_main.py \
   --model_dir $MLP_GCS_MODEL_DIR \
   --data_dir $MLP_PATH_GCS_NCF \
   --dataset "ml-20m" --hooks "" \
   --tpu $MLP_TPU_NAME \
   --clean \
   --train_epochs 14 \
   --batch_size 98304 \
   --eval_batch_size 100000 \
   --learning_rate=0.00382059 \
   --beta1=0.783529 \
   --beta2=0.909003 \
   --epsilon=1.45439e-07 \
   --layers 256,256,128,64 \
   --num_factors 64 \
   --hr_threshold 0.635 \
   --ml_perf

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"

cat $STITCHED_COMPLIANCE_FILE

# report result 
result=$(( $end - $start )) 
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

