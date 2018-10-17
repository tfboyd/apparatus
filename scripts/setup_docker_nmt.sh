#!/bin/bash
# Set working directory
set -e 

apt-get update
apt-get install wget
apt-get install -y python3.6
apt-get install -y python3-pip


apt-get install -y --no-install-recommends ca-certificates
apt-get install -y virtualenv htop
apt-get install -y python-setuptools

echo Updating Pip3
#pip3 install --upgrade pip

echo Installing Sacrebleu
pip3 install sacrebleu


echo 'Installing TF'
pip3 install --user tf-nightly-gpu==1.12.0.dev20181004

echo "Cloning moses for data processing"
pushd staging/models/rough/nmt_gpu
git clone https://github.com/moses-smt/mosesdecoder.git "mosesdecoder"
pushd mosesdecoder
git reset --hard 8c5eaa1a122236bbf927bde4ec610906fea599e6
popd
popd

#pip3 install --upgrade pip==9.0.3
#pip3 install pyyaml
#pip3 install --upgrade setuptools
#pip3 install absl-py
#pip3 install tensorflow-gpu==1.10.0


#apt-get -y install zip unzip
#apt-get -y build-dep python-matplotlib  # install dependencies required by matplotlib

#pip3 install -r /root/garden/official/requirements.txt


