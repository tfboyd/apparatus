set -e



TF_BENCHMARKS_REPO="https://github.com/tensorflow/benchmarks.git"
TF_BENCHMARKS_DIR="benchmarks"
TF_MODELS_REPO="https://github.com/tensorflow/models.git"
TF_MODELS_DIR="models"
COCO_API_REPO="https://github.com/cocodataset/cocoapi.git"
COCO_API_DIR="cocoapi"

# run benchmark

# Quality of 0.2 is roughly a few hours of work
# 0.749 is the final target quality

echo `pwd`


pushd ${TF_MODELS_DIR}/research
# Install protobuf compiler and use it to process proto files
wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip
unzip protobuf.zip
./bin/protoc object_detection/protos/*.proto --python_out=.
popd

pushd ${COCO_API_DIR}/PythonAPI
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
pip install --user setuptools cython matplotlib
#make
python3 setup.py build_ext --inplace
popd


pip install tf-nightly-gpu


export PYTHONPATH=`pwd`/${TF_MODELS_DIR}:`pwd`/${TF_MODELS_DIR}/research:`pwd`/${COCO_API_DIR}/PythonAPI:$PYTHONPATH

python3 $HOME/${TF_BENCHMARKS_DIR}/scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
	--model=ssd300 --data_name=coco \
	--num_gpus=1 --batch_size=128 --variable_update=parameter_server \
	--optimizer=momentum --weight_decay=5e-4 --momentum=0.9 \
	--backbone_model_path=/data/resnet34/model.ckpt-28152 --data_dir=/data/coco2017 \
	--num_epochs=60 --train_dir=/output/gce_1gpu_batch128_`date +%m%d%H%M` \
	--save_model_steps=5000 --max_ckpts_to_keep=250 --summary_verbosity=1 --save_summaries_steps=10 \
	--use_fp16 --alsologtostderr


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"

# report result 
result=$(( $end - $start )) 
result_name="resnet"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"
