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
  --learning_rate=0.002 \
  --use_fp32_batch_matmul=true \
  --detokenizer_file=mosesdecoder/scripts/tokenizer/detokenizer.perl


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"

# report result 
result=$(( $end - $start )) 
result_name="resnet"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"
