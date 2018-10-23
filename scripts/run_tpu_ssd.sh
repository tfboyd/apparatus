#!/bin/bash

set -e


PYTHONPATH=""

# TODO(taylorrobie): properly open source backbone checkpoint

#python3 -m venv pyenv
#source pyenv/bin/activate


export PYTHONPATH="$(pwd)/cloud_tpu/models/official/retinanet:${PYTHONPATH}"
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

python3 ssd_main.py  --use_tpu=True \
                     --tpu_name=${MLP_TPU_NAME} \
                     --device=tpu \
                     --num_shards=8 \
                     --mode=train_and_eval \
                     --eval_after_training \
                     --train_batch_size=256 \
                     --training_file_pattern="${MLP_PATH_GCS_SSD}/train-*" \
                     --eval_batch_size=8 \
                     --validation_file_pattern="${MLP_PATH_GCS_SSD}/val-*" \
                     --val_json_file="${MLP_PATH_GCS_SSD}/raw-data/annotations/instances_val2017.json" \
                     --resnet_checkpoint=${MLP_GCS_RESNET_CHECKPOINT} \
                     --model_dir=${MLP_GCS_MODEL_DIR} \
                     --num_epochs=64 \
                     --hparams=use_bfloat16=true \
                     --iterations_per_loop=1000

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

