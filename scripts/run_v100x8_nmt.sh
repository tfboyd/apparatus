set -e


cd staging/models/rough/nmt_gpu

echo 'Starting the time!'
# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)


BATCH_SIZE=180
NUM_GPUS=8


python3 nmt.py \
  --data_dir=/data/ \
  --out_dir=/output/ \
  --batch_size=${BATCH_SIZE} \
  --num_gpus=${NUM_GPUS} \
  --learning_rate=0.002 \
  --use_fp32_batch_matmul=false \
  --detokenizer_file=mosesdecoder/scripts/tokenizer/detokenizer.perl


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"

# report result 
result=$(( $end - $start )) 
result_name="resnet"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"
