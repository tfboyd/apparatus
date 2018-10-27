#!/bin/bash

set -e


cd staging/models/rough/nmt/

#source /tmp/nmt_env/bin/activate
pip3 install $MLP_TF_PIP_LINE

# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)

echo Data Dir $MLP_PATH_GCS_NMT
CMD="python3 nmt.py \
  --activation_dtype=bfloat16 \
  --learning_rate=0.002 \
  --batch_size=4096 \
  --max_train_epochs=3 \
  --data_dir=$MLP_PATH_GCS_NMT \
  --tpu_name=$MLP_TPU_NAME \
  --use_tpu=true \
  --mode=train \
  --num_buckets=1 \
  --out_dir=$MLP_GCS_MODEL_DIR \
  --run_name=nmt_512.adam.label_smoothing.no_bpe.train.512.5e-4_5000_ckpt \
  --warmup_steps=200"


EVAL_CMD="python3 nmt.py \
	--activation_dtype=bfloat16 \
	  --data_dir=$MLP_PATH_GCS_NMT \
	--mode=infer \
	--num_buckets=1 \
	  --out_dir=$MLP_GCS_MODEL_DIR \
	--run_name=nmt_8192sorted_no_reshuffle_8192 \
	--target_bleu=22"



timeout 4h $CMD &
timeout 4h $EVAL_CMD


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

