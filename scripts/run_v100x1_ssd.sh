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


cd ${TF_MODELS_DIR}/research
# Install protobuf compiler and use it to process proto files
wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip
unzip protobuf.zip
./bin/protoc object_detection/protos/*.proto --python_out=.

cd ${COCO_API_DIR}/PythonAPI
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py --user
pip install --user setuptools cython matplotlib
make


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="resnet"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"
