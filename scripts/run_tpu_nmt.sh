#!/bin/bash

set -e


cd staging/models/rough/nmt/

source /tmp/nmt_env/bin/activate
pip install tf-nightly

# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)


echo Data Dir $MLP_PATH_GCS_NMT
python nmt.py \
  --activation_dtype=bfloat16 \
  --batch_size=512 \
  --nobinarylog \
  --data_dir=$MLP_PATH_GCS_NMT \
  --tpu_name=$MLP_TPU_NAME \
  --use_tpu=true \
  --mode=train \
  --num_buckets=1 \
  --out_dir=$MLP_GCS_MODEL_DIR \
  --rpclog=-1 \
  --run_name=nmt_512.adam.label_smoothing.no_bpe.train.512.5e-4_5000_ckpt


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

