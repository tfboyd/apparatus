
set -e

export PYTHONPATH=`pwd`/models:$PYTHONPATH
export PYTHONPATH=`pwd`/tpu/models:$PYTHONPATH

# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)


echo "STARTING TIMING RUN AT $start_fmt"
#python3 tpu/models/official/resnet/resnet_main.py --tpu=$MLP_TPU_NAME --data_dir=$MLP_PATH_GCS_IMAGENET --model_dir=${MLP_GCS_MODEL_DIR} --train_batch_size=1024 --iterations_per_loop=112603 --mode=train --eval_batch_size=1000 --tpu_zone=us-central1-b --num_cores=8 --train_steps=112603
# Decreased iters per look to debug
#python3 tpu/models/official/resnet/resnet_main.py --tpu=$MLP_TPU_NAME --data_dir=$MLP_PATH_GCS_IMAGENET --model_dir=${MLP_GCS_MODEL_DIR} --train_batch_size=1024 --iterations_per_loop=10000 --mode=train --eval_batch_size=1000 --tpu_zone=us-central1-b --num_cores=8 --train_steps=112603


EVAL_CMD="python3 tpu/models/official/resnet/resnet_main.py \
	--data_dir=$MLP_PATH_GCS_IMAGENET \
	--eval_batch_size=256 \
	--iterations_per_loop=1252 \
	--mode=eval \
	--model_dir=${MLP_GCS_MODEL_DIR} \
	--num_cores=8 \
	--resnet_depth=50 \
	--steps_per_eval=100 \
	--tpu=$MLP_TPU_SIDECAR_NAME \
	--train_batch_size=4096 \
	--train_steps=28152 "

timeout 2h python3 tpu/models/official/resnet/resnet_main.py \
	--data_dir=$MLP_PATH_GCS_IMAGENET \
	--eval_batch_size=256 \
	--iterations_per_loop=1252 \
	--mode=train \
	--model_dir=${MLP_GCS_MODEL_DIR} \
	--num_cores=32 \
	--resnet_depth=50 \
	--skip_host_call \
	--steps_per_eval=100 \
	--tpu=$MLP_TPU_NAME \
	--train_batch_size=4096 \
	--train_steps=28152 \
	--use_async_checkpointing &

timeout 2h $EVAL_CMD



# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="resnet"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"


