
set -e

export PYTHONPATH=`pwd`/models:$PYTHONPATH
export PYTHONPATH=`pwd`staging/models/rough/:$PYTHONPATH

# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)


echo "STARTING TIMING RUN AT $start_fmt"
#python3 tpu/models/official/resnet/resnet_main.py --tpu=$MLP_TPU_NAME --data_dir=$MLP_PATH_GCS_IMAGENET --model_dir=${MLP_GCS_MODEL_DIR} --train_batch_size=1024 --iterations_per_loop=112603 --mode=train --eval_batch_size=1000 --tpu_zone=us-central1-b --num_cores=8 --train_steps=112603
# Decreased iters per look to debug


cd staging/models/rough/

# --mode=train
python3 resnet/resnet_main.py \
  --nocondv2 \
  --data_dir=$MLP_PATH_GCS_IMAGENET \
  --eval_batch_size=1024 \
  --tpu_zone=us-central1-b \
  --iterations_per_loop=1000 \
  --mode=in_memory_eval \
  --model_dir=${MLP_GCS_MODEL_DIR} \
  --num_cores=8 \
  --resnet_depth=50 \
  --steps_per_eval=5000 \
  --tpu=$MLP_TPU_NAME \
  --train_batch_size=1024 \
  --train_steps=112603

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="resnet"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"


