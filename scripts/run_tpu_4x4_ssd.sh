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
python3 ssd_main.py  --use_tpu=True \
                     --tpu_name=${MLP_TPU_NAME} \
                     --device=tpu \
                     --train_batch_size=1024 \
                     --training_file_pattern="${MLP_PATH_GCS_SSD}/train-*" \
                     --resnet_checkpoint=${MLP_GCS_RESNET_CHECKPOINT} \
                     --model_dir=${MLP_GCS_MODEL_DIR} \
		     --num_epochs=64 \
		     --hparams=use_bfloat16=true,lr_warmup_epoch=4.5,weight_decay=8e-4 \
		     --num_shards=32 \
		     --iterations_per_loop=625 \
		     --mode=train &


# Evaluation command
python3 ssd_main.py  --use_tpu=True \
	--device=tpu \
	--eval_batch_size=8 \
	--hparams=use_bfloat16=false \
	--min_eval_interval=0 \
	--mode=eval \
        --model_dir=${MLP_GCS_MODEL_DIR} \
	--num_epochs=64 \
        --tpu_name=${MLP_TPU_SIDECAR_NAME} \
	--train_batch_size=1024 \
	--val_json_file="${MLP_PATH_GCS_SSD}/instances_val2017.json" \
	--validation_file_pattern="${MLP_PATH_GCS_SSD}/val-*"

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
