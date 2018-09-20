
set -e
HOST=`hostname`
SECONDS=`date +%s`

# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)

echo "STARTING TIMING RUN AT $start_fmt"
#python3 tpu/models/official/resnet/resnet_main.py --tpu=$MLP_TPU_NAME --data_dir=$MLP_PATH_GCS_IMAGENET --model_dir=${MLP_GCS_MODEL_DIR}/${HOST}-${SECONDS} --train_batch_size=1024 --iterations_per_loop=112603 --mode=train --eval_batch_size=1000 --tpu_zone=us-central1-b --num_cores=8 --train_steps=112603
# Decreased iters per look to debug
python3 tpu/models/official/resnet/resnet_main.py --tpu=$MLP_TPU_NAME --data_dir=$MLP_PATH_GCS_IMAGENET --model_dir=${MLP_GCS_MODEL_DIR}/${HOST}-${SECONDS} --train_batch_size=1024 --iterations_per_loop=10000 --mode=train --eval_batch_size=1000 --tpu_zone=us-central1-b --num_cores=8 --train_steps=112603



# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="resnet"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"


