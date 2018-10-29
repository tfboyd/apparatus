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
  --batch_size=1024 \
  --data_dir=$MLP_PATH_GCS_NMT \
  --tpu_name=special-jf \
  --use_tpu=true \
  --mode=train_and_eval \
  --num_buckets=5 \
  --out_dir=$MLP_GCS_MODEL_DIR \
  --skip_host_call=true \
  --run_name=nmt_512.adam.label_smoothing.no_bpe.train.512.5e-4_5000_ckpt"

$CMD


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

