#!/bin/bash
# Set working directory
set -e 

apt-get update
apt-get install wget
apt-get install -y python3.6
apt-get install -y python3-pip
pip3 install --upgrade pip

apt-get update && apt-get install -y --no-install-recommends ca-certificates
apt-get install -y virtualenv htop
apt-get install -y python-setuptools

#pip3 install --upgrade pip==9.0.3
#pip3 install pyyaml
#pip3 install --upgrade setuptools
#pip3 install absl-py
#pip3 install tensorflow-gpu==1.10.0


curl https://raw.githubusercontent.com/haoyuz/gce-scripts/cuda-9.2/cuda-bin/ptxas -o ptxas
chmod +x ptxas
mv ptxas /usr/local/cuda/bin/


apt-get -y install zip unzip
echo 'Installing build dep'
apt-get -y build-dep # install dependencies required by matplotlib
echo 'Installing python matplotlib'
apt-get -y python-matplotlib  # install dependencies required by matplotlib

#pip3 install -r /root/garden/official/requirements.txt


