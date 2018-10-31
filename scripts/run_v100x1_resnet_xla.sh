set -e

###
# Warning: this should train as expected 74.9+ at 61 epochs. But the learning
# rate has not been tested for 1 GPU as of 31-OCT-2018. tobyboyd@
########################

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
  --variable_update=parameter_server \
  --num_warmup_batches=0 \
  --use_fp16=True \
  --nodistortions \
  --num_epochs=61 \
  --ml_perf \
  --local_parameter_device=gpu \
  --num_gpus=1 \
  --display_every=100 \
  --xla_compile=True \
  --eval_during_training_at_specified_epochs='1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61' \
  --num_eval_batches=200 \
  --eval_batch_size=250 \
  --loss_type_to_report=base_loss \
  --single_l2_loss_op \
  --compute_lr_on_cpu \
  --resnet_base_lr=0.05 \
  --ml_perf_compliance_logging=True

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result
result=$(( $end - $start ))
result_name="resnet"


echo "RESULT,$result_name,$seed,$result,$USER,$start_fmt"
