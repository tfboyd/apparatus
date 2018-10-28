#!/bin/bash

echo Updating gsutil
gcloud components update
echo Done Updating gsutil

set -e 

# Not sure why this happens... but it sometimes causes errors if not...
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -


sudo apt-get update
sudo apt-get install -y python3.6
sudo apt-get install -y python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install virtualenv
sudo pip3 install pyyaml

# Note: this could be over-ridden later

TF_TO_INSTALL=${MLP_TF_PIP_LINE:-tf-nightly}
sudo pip3 install $TF_TO_INSTALL

sudo pip3 install --upgrade oauth2client
sudo pip3 install --upgrade google-api-python-client
sudo pip3 install google-cloud
sudo pip3 install mlperf_compliance==0.0.6

echo 'TPU Host Freeze pip'
pip freeze
echo
echo
echo
echo 'TPU Host Freeze pip3'
pip3 freeze

