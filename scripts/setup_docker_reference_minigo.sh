#!/bin/bash
# Set working directory
set -e 

apt-get update
apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates
apt-get install -y virtualenv htop
apt-get install -y python-setuptools
pip3 install --upgrade pip
pip3 install tensorflow-gpu
pip3 install virtualenv
pip3 install virtualenvwrapper
pip3 install -r /root/reference/reinforcement/tensorflow/minigo/requirements.txt


mkdir -p /research/results/minigo/final/
