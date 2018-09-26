#!/bin/bash

set -e


PYTHONPATH=""

# TODO(taylorrobie): properly open source backbone checkpoint

#python3 -m venv pyenv
#source pyenv/bin/activate


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


sudo pip3 install tf-nightly


export PYTHONPATH="$(pwd)/cloud_tpu/models/official/retinanet:${PYTHONPATH}"
python3 ssd_main.py  --use_tpu=True \
                     --tpu_name=${MLP_TPU_NAME} \
                     --device=tpu \
                     --train_batch_size=32 \
                     --training_file_pattern="${MLP_PATH_GCS_SSD}/train-*" \
                     --resnet_checkpoint=${MLP_GCS_RESNET_CHECKPOINT} \
                     --model_dir=${MLP_GCS_MODEL_DIR} \
                     --num_epochs=60

python3 ssd_main.py  --use_tpu=True \
                     --tpu_name=${MLP_TPU_NAME} \
                     --device=tpu \
                     --mode=eval \
                     --eval_batch_size=256 \
                     --validation_file_pattern="${MLP_PATH_GCS_SSD}/val-*" \
                     --val_json_file="${MLP_PATH_GCS_SSD}/raw-data/annotations/instances_val2017.json" \
                     --model_dir=${MLP_GCS_MODEL_DIR} \
                     --eval_timeout=0

