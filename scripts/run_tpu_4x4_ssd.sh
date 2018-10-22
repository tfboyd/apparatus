#!/bin/bash

set -e


PYTHONPATH=""


cd staging/models/rough/ssd/



#chmod +x open_source/.setup_env.sh
#./open_source/.setup_env.sh
CLOUD_TPU="cloud_tpu"
PYTHONPATH=""
if [ ! -d $CLOUD_TPU ]; then
  git clone https://github.com/tensorflow/tpu.git $CLOUD_TPU
fi
pushd $CLOUD_TPU
# TODO(taylorrobie): Change to 'git checkout SHA' for official submission.
git pull
popd


sudo pip3 install $MLP_TF_PIP_LINE

# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)


#--hparams=use_bfloat16=true,lr_warmup_steps=18750 \
export PYTHONPATH="$(pwd)/cloud_tpu/models/official/retinanet:${PYTHONPATH}"
python3 ssd_main.py  --use_tpu=True \
                     --tpu_name=${MLP_TPU_NAME} \
                     --device=tpu \
                     --train_batch_size=1024 \
                     --training_file_pattern="${MLP_PATH_GCS_SSD}/train-*" \
                     --resnet_checkpoint=${MLP_GCS_RESNET_CHECKPOINT} \
                     --model_dir=${MLP_GCS_MODEL_DIR} \
                     --num_epochs=61 \
		     --hparams=use_bfloat16=true,lr_warmup_epoch=4.5,weight_decay=8e-4 \
		     --num_shards=32 \
		     --iterations_per_loop=1000 \
		     --mode=train \
		     --rpclog=-1



#sleep 300
#
#python3 ssd_main.py  --use_tpu=True \
#                     --tpu_name=${MLP_TPU_NAME} \
#                     --device=tpu \
#                     --mode=eval \
#                     --eval_batch_size=256 \
#                     --validation_file_pattern="${MLP_PATH_GCS_SSD}/val-*" \
#                     --val_json_file="${MLP_PATH_GCS_SSD}/raw-data/annotations/instances_val2017.json" \
#                     --model_dir=${MLP_GCS_MODEL_DIR} \
#                     --eval_timeout=0


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

