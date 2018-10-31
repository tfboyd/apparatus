set -e



echo 'Starting the time!'
# start timing
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)

CMD="t2t-trainer \
  --data_dir=$MLP_PATH_GCS_TRANSFORMER/data/ \
  --problem=translate_ende_wmt32k \
  --model=transformer \
  --hparams_set=transformer_big \
	--output_dir=/output/model \
  --decode_reference=$MLP_PATH_GCS_TRANSFORMER/wmt14-en-de.ref \
  --decode_hparams=batch_size=64,beam_size=4,alpha=0.6,extra_length=50 \
  --hparams=batch_size=512,learning_rate_constant=4.0 \
  --schedule=continuous_train_and_eval \
  --decode_from_file=$MLP_PATH_GCS_TRANSFORMER/wmt14-en-de.src \
  --decode_to_file=/output/decode.transformer_mlperf_gpu.translate_ende_wmt32k \
  --objective=losses/training \
  --optionally_use_dist_strat \
  --worker_gpu=1
"

echo $CMD
$CMD


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"

# report result
result=$(( $end - $start ))
result_name="resnet"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"
