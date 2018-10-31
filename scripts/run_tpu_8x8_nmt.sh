#!/bin/bash

set -e


cd staging/models/rough/nmt/

#source /tmp/nmt_env/bin/activate
pip install $MLP_TF_PIP_LINE

# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)

echo Data Dir $MLP_PATH_GCS_NMT
CMD="python3 nmt.py \
  --data_dir=$MLP_PATH_GCS_NMT \
  --tpu_name=$MLP_TPU_NAME \
  --out_dir=$MLP_GCS_MODEL_DIR \
  --use_tpu=true \
  \
     --activation_dtype=bfloat16   \
     --batch_size=16384   \
     --decay_scheme=luong234   \
     --learning_rate=0.008   \
     --max_train_epochs=4   \
     --mode=train   \
     --run_name=nmt_16384head_2_jf_16384   \
     --warmup_steps=200  \
  "

EVAL_COMMAND="python3 nmt.py \
  --data_dir=$MLP_PATH_GCS_NMT \
  --tpu_name=$MLP_TPU_NAME \
  --out_dir=$MLP_GCS_MODEL_DIR \
  --use_tpu=true \
  \
     --activation_dtype=bfloat16   \
     --mode=infer   \
     --num_buckets=1   \
     --run_name=nmt_16384head_2_jf_16384   \
     --target_bleu=22   \

"

timeout 3h $CMD &
timeout 3h $EVAL_CMD

wait
STAT=$?

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"
exit $STAT
