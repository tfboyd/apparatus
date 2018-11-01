#!/bin/bash

set -e


PYTHONPATH=""


export PYTHONPATH="$(pwd)/tpu/models/official/retinanet:${PYTHONPATH}"
echo 'Retinanet contains:'
echo $(pwd)/tpu/models/official/retinanet
ls -lah $(pwd)/tpu/models/official/retinanet
echo
echo
cd staging/models/rough/ssd/

sudo pip install $MLP_TF_PIP_LINE

# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)



#--hparams=use_bfloat16=true,lr_warmup_steps=18750 \
#tpu/models/official/retinanet

echo PYTHONPATH $PYTHONPATH


# Train Command
python3 ssd_main.py  \
        --tpu_name=${MLP_TPU_NAME} \
        --training_file_pattern="${MLP_PATH_GCS_SSD}/train-*" \
	--resnet_checkpoint=${MLP_GCS_RESNET_CHECKPOINT} \
        --model_dir=${MLP_GCS_MODEL_DIR} \
     \
     --hparams=use_bfloat16=true,lr_warmup_epoch=25.0,first_lr_drop_epoch=70.0,second_lr_drop_epoch=90.0,weight_decay=1e-3   \
     --iterations_per_loop=312   \
     --mode=train   \
     --num_epochs=128   \
     --num_shards=128   \
     --train_batch_size=4096   \
     --transpose_tpu_infeed=true \
     --use_tpu  &


# Evaluation command
python3 ssd_main.py \
        --model_dir=${MLP_GCS_MODEL_DIR} \
        --tpu_name=${MLP_TPU_SIDECAR_NAME} \
	--val_json_file="${MLP_PATH_GCS_SSD}/instances_val2017.json" \
	--validation_file_pattern="${MLP_PATH_GCS_SSD}/val-*" \
	\
     --device=tpu   \
     --eval_batch_size=8   \
     --hparams=use_bfloat16=false   \
     --min_eval_interval=0   \
     --mode=eval   \
     --num_epochs=128   \
     --train_batch_size=4096   \
     --transpose_tpu_infeed=true \
     --use_tpu


wait

my_status=$?

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

exit $my_status
