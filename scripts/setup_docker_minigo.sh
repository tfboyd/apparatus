#!/bin/bash
# Set working directory
set -e 

apt-get update
apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates
apt-get install -y virtualenv htop
apt-get install -y python-setuptools
apt-get install -y python-pip
#pip install --upgrade pip
pip install --upgrade pip==9.0.3
pip install --upgrade setuptools
pip install virtualenv
pip install virtualenvwrapper

mkdir /root/tf

TF_TYPE="gpu" # Change to "gpu" for GPU support
OS="linux" # Change to "darwin" for macOS
TARGET_DIRECTORY="/root/tf"
curl -L "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-${TF_TYPE}-${OS}-x86_64-1.10.1.tar.gz" > tf.tar.gz
tar -C $TARGET_DIRECTORY -xzf tf.tar.gz

export LIBRARY_PATH=$LIBRARY_PATH:/root/tf/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/tf/lib

#ls -lah /root/tf
#exit 1


cd /root
#virtualenv minigo_env
#source minigo_env/bin/activate

pip install tf-nightly-gpu


pip install -r /root/mlperf/reference/reinforcement/tensorflow/minigo/requirements.txt 
pip install numpy

echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | apt-key add -


apt-get update && apt-get install -y bazel
dpkg -i /root/minigo_data/minigo/nv-tensorrt-repo-ubuntu1604-cuda9.2-ga-trt4.0.1.6-20180612_1-1_amd64.deb
apt-get update
apt-get install -y tensorrt python3-libnvinfer-doc uff-converter-tf libnvinfer4

sh -c "echo '/usr/local/cuda/lib64' > /etc/ld.so.conf.d/cuda.conf" 
ldconfig

cd /root/tensorflow/minigo/
./cc/configure_tensorflow.sh
cd /root

mkdir -p /research/results/minigo/final/
mkdir -p /root/results/minigo/final/stats

