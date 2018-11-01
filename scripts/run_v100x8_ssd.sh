set -e

TF_BENCHMARKS_DIR="benchmarks"
TF_MODELS_DIR="models"
COCO_API_DIR="cocoapi"

# run benchmark
echo `pwd`

pushd ${TF_MODELS_DIR}/research
# Install protobuf compiler and use it to process proto files
# Why isn't this already done and stored on disk???
wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip
unzip protobuf.zip
./bin/protoc object_detection/protos/*.proto --python_out=.
popd


pushd ${COCO_API_DIR}/PythonAPI
# Both of these seem like they coudl be in the Docker as normal tools we use.
# The versions do not seem specific.
python -m pip install --user setuptools cython matplotlib
popd

export PYTHONPATH=`pwd`/${TF_MODELS_DIR}:`pwd`/${TF_MODELS_DIR}/research:`pwd`/${COCO_API_DIR}/PythonAPI:$PYTHONPATH

# start timing
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)

python $HOME/${TF_BENCHMARKS_DIR}/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
  --model=ssd300 \
  --data_name=coco \
  --data_dir=/data/coco2017 \
  --backbone_model_path=/data/resnet34/model.ckpt-28152 \
  --optimizer=momentum \
  --weight_decay=5e-4 \
  --momentum=0.9 \
  --num_gpus=8 \
  --batch_size=64 \
  --use_fp16 \
  --xla_compile \
  --num_epochs=80 \
  --num_eval_epochs=1.9 \
  --num_warmup_batches=0 \
  --eval_during_training_at_specified_steps='7500,10000,11250,12500,13750,15000' \
  --datasets_num_private_threads=100 \
  --num_inter_threads=160 \
  --variable_update=replicated \
  --all_reduce_spec=nccl \
  --gradient_repacking=2 \
  --stop_at_top_1_accuracy=0.212 \
  --ml_perf_compliance_logging


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"

# report result
result=$(( $end - $start ))
result_name="ssd"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"
