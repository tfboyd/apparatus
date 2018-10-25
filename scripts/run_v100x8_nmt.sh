set -e


cd staging/models/rough/nmt_gpu

echo 'Starting the time!'
# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)


BATCH_SIZE=1440
NUM_GPUS=8




python3 nmt.py \
  --data_dir=/data/ \
  --out_dir=/output/ \
  --all_reduce_spec=nccl \
  --enable_auto_loss_scale=false \
  --fixed_loss_scale=128 \
  --batch_size=${BATCH_SIZE} \
  --check_tower_loss_numerics=false \
  --num_gpus=${NUM_GPUS} \
  --use_fp32_batch_matmul=true \
  --detokenizer_file=mosesdecoder/scripts/tokenizer/detokenizer.perl \
  --learning_rate=0.001 \
  --mode=train_and_eval \
  --use_block_lstm=true \
  --use_fused_lstm=true \
  --use_fp16=true \
  --fp16_loss_scale=128 \
  --use_xla=false \
  --learning_rate=0.001 \
  --warmup_steps=200 \
  --decay_scheme=luong234 \
  --use_fused_lstm_dec=true \
  --show_metrics=true

# --use_fused_lstm_dec this is new feature. set to false if only trying to test compliance.

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"

# report result 
result=$(( $end - $start )) 
result_name="resnet"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"
