#!/bin/bash
# Set working directory
set -e 

apt-get update
apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates
apt-get install -y virtualenv htop
apt-get install -y python-setuptools
pip3 install --upgrade pip
pip3 install --upgrade setuptools
pip3 install tf-nightly-gpu
pip3 install virtualenv
pip3 install virtualenvwrapper


cd /root/reference
virtualenv minigo_env
source minigo_env/bin/activate

pip3 install -r /root/reference/reinforcement/tensorflow/minigo/requirements.txt


mkdir -p /research/results/minigo/final/
mkdir -p /root/results/minigo/final/stats
