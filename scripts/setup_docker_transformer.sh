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

apt-get install -y python-numpy python-scipy

echo Updating Pip3
#pip3 install --upgrade pip

echo Installing Sacrebleu
pip3 install sacrebleu


echo 'Installing TF'
pip3 install --user tensorflow-gpu==1.12.0rc1

pip3 install mlperf_compliance

pip3 install pyasn1==0.4.1

cd t2t


python3 setup.py install 

#pip3 install --upgrade pip==9.0.3
#pip3 install pyyaml
#pip3 install --upgrade setuptools
#pip3 install absl-py
#pip3 install tensorflow-gpu==1.10.0


#apt-get -y install zip unzip
#apt-get -y build-dep python-matplotlib  # install dependencies required by matplotlib

#pip3 install -r /root/garden/official/requirements.txt


