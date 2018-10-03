#!/bin/bash
# Set working directory
set -e 

apt-get update
apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates
apt-get install -y virtualenv htop
apt-get install -y python-setuptools
apt-get install -y python3-pip
apt-get install -y unzip
#pip install --upgrade pip
pip3 install --upgrade pip==9.0.3
pip3 install --upgrade setuptools
pip3 install virtualenv
pip3 install virtualenvwrapper

apt-get update
apt-get install python3-pip
#pip3 install -r /home/gerrit/tensorflow/minigo/requirements.txt
pip install -r /root/mlperf/reference/reinforcement/tensorflow/minigo/requirements.txt 
#pip install tensorflow-gpu==1.11.0rc1
pip3 install tf-nightly-gpu
apt-get install wget

# Download and extract tarball manually (needs to be this version exactly for TensorRT below)

#CUDNN_INSTALLER=cudnn-9.0-linux-x64-v7.1.3

#rsync -ahv --ignore-existing $CUDNN_INSTALLER/cuda/ /usr/local/cuda/


# Download and extract tarball manually
# dpkg -i /root/minigo_data/minigo/nv-tensorrt-repo-ubuntu1604-cuda9.2-ga-trt4.0.1.6-20180612_1-1_amd64.deb

#
# dpkg -i /root/minigo_data/minigo/nv-tensorrt-repo-ubuntu1604-cuda9.0-ga-trt4.0.1.6-20180612_1-1_amd64.deb

TENSORRT_NAME=TensorRT-4.0.1.6.Ubuntu-16.04.4.x86_64-gnu.cuda-9.0.cudnn7.1
TENSORRT_TARNAME=$TENSORRT_NAME.tar.gz
TENSORRT_TARBALL=/root/minigo_data/minigo/$TENSORRT_TARNAME

mv $TENSORRT_TARBALL $TENSORRT_TARNAME
tar xzf $TENSORRT_TARNAME

TENSORRT_INSTALLER=/root/TensorRT-4.0.1.6

# Note that the mlperf branch at HEAD currently expects them in /usr/{lib,include}/x86-gnu-linux

echo 'TRT INSTALL DIR: ' $TENSORRT_INSTALLER
ls $TENSORRT_INSTALLER
echo
echo
echo 'Cudas: '
ls /usr/local | grep cuda
echo
echo


rsync -ahv --ignore-existing $TENSORRT_INSTALLER/lib/ /usr/local/cuda/lib64/

rsync -ahv --ignore-existing $TENSORRT_INSTALLER/include/ /usr/local/cuda/lib64/include

pip3 install $TENSORRT_INSTALLER/python/tensorrt-4.0.1.6-cp35-cp35m-linux_x86_64.whl
pip3 install $TENSORRT_INSTALLER/uff/uff-0.4.0-py2.py3-none-any.whl
pip3 install $TENSORRT_INSTALLER/graphsurgeon/graphsurgeon-0.2.0-py2.py3-none-any.whl


BAZEL_INSTALLER=bazel-0.17.1-installer-linux-x86_64.sh

wget https://github.com/bazelbuild/bazel/releases/download/0.17.1/$BAZEL_INSTALLER

chmod +x $BAZEL_INSTALLER

./$BAZEL_INSTALLER




#
# mkdir /root/tf
# 
# TF_TYPE="gpu" # Change to "gpu" for GPU support
# OS="linux" # Change to "darwin" for macOS
# TARGET_DIRECTORY="/root/tf"
# #curl -L "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-${TF_TYPE}-${OS}-x86_64-1.10.1.tar.gz" > tf.tar.gz
# #tar -C $TARGET_DIRECTORY -xzf tf.tar.gz
# 
# #export LIBRARY_PATH=$LIBRARY_PATH:/root/tf/lib
# #export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/tf/lib
# 
# #ls -lah /root/tf
# #exit 1
# 
# 
# cd /root
# #virtualenv minigo_env
# #source minigo_env/bin/activate
# 
# pip install tf-nightly-gpu
# 
# 
# pip install -r /root/mlperf/reference/reinforcement/tensorflow/minigo/requirements.txt 
# pip install numpy
# 
# #echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
# #curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
# 
# #apt-get update && apt-get install -y bazel
# 
# BAZEL_INSTALLER=bazel-0.17.1-installer-linux-x86_64.sh
# 
# wget https://github.com/bazelbuild/bazel/releases/download/0.17.1/$BAZEL_INSTALLER
# 
# chmod +x $BAZEL_INSTALLER
# 
# ./$BAZEL_INSTALLER
# 
# 
# 
# dpkg -i /root/minigo_data/minigo/nv-tensorrt-repo-ubuntu1604-cuda9.2-ga-trt4.0.1.6-20180612_1-1_amd64.deb
# apt-get update
# apt-get install -y tensorrt python3-libnvinfer-doc uff-converter-tf libnvinfer4
# 
# 
# # use cuda 9.1 -- what he builds against
# # current version of TF is: try using 1.11-gpu
# sh -c "echo '/usr/local/cuda/lib64' > /etc/ld.so.conf.d/cuda.conf" 
# ldconfig
# 
# #cd /root/tensorflow/minigo/
# # omit on head riht now
# #./cc/configure_tensorflow.sh
# #cd /root
# 
# # be in teh minigo directory
# # or just call run and time which will build
# 
# mkdir -p /research/results/minigo/final/
# mkdir -p /root/results/minigo/final/stats
# 
