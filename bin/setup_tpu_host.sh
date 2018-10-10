#!/bin/bash

set -e 

# Not sure why this happens... but it sometimes causes errors if not...
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -


sudo apt-get update
sudo apt-get install -y python3
sudo apt-get install python3.4-venv
sudo pip install --upgrade pip
sudo pip3 install --upgrade pip
sudo pip install pyyaml

# Note: this could be over-ridden later

TF_TO_INSTALL=${MLP_TF_PIP_LINE:-tf-nightly}
sudo pip3 install $TF_TO_INSTALL

sudo pip3 install --upgrade oauth2client
sudo pip3 install --upgrade google-api-python-client
sudo pip3 install google-cloud

echo 'TPU Host Freeze pip'
pip freeze
echo
echo
echo
echo 'TPU Host Freeze pip3'
pip3 freeze

