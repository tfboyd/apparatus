set -e

# start timing
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)
echo "STARTING TIMING RUN AT $start_fmt"


# run benchmark
cd benchmarks/scripts/
python3 -c 'import tensorflow; print(tensorflow.__version__)'

python3 tf_cnn_benchmarks/tf_cnn_benchmarks.py --data_format=NCHW \
  --batch_size=256 \
  --model=resnet50_v1.5 \
  --data_dir=/data/imagenet/combined/ \
  --optimizer=momentum \
  --weight_decay=1e-4 \
  --variable_update=replicated \
  --num_warmup_batches=0 \
  --all_reduce_spec=nccl \
  --use_fp16=True \
  --nodistortions \
  --gradient_repacking=2 \
  --datasets_use_prefetch=False \
  --train_dir=/output \
  --summary_verbosity=1 \
  --save_summaries_steps=100 \
  --num_epochs=81 \
  --local_parameter_device=gpu \
  --num_gpus=8 \
  --display_every=10 \
  --xla_compile=True \
  --datasets_use_caching=True \
  --datasets_parallel_interleave_cycle_length=64 \
  --datasets_sloppy_parallel_interleave=True \
  --datasets_parallel_interleave_prefetch=256


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result
result=$(( $end - $start ))
result_name="resnet"


echo "RESULT,$result_name,$seed,$result,$USER,$start_fmt"
