#!/bin/bash

echo Updating gsutil
gcloud components update
echo Done Updating gsutil

set -e

# Not sure why this happens... but it sometimes causes errors if not...
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -


lsb_release -a

sudo apt-get update
sudo apt-get install -y expect
sudo apt-get install -y python3-pip virtualenv python-virtualenv

which python3
python3 --version

virtualenv -p python3 ${RUN_VENV}
source ${RUN_VENV}/bin/activate
pip --version

pip install --upgrade pyyaml oauth2client google-api-python-client google-cloud
pip install mlperf_compliance==0.0.9
pip install cloud-tpu-profiler==1.12


# Note: this could be over-ridden later
TF_TO_INSTALL=${MLP_TF_PIP_LINE:-tf-nightly}
pip install $TF_TO_INSTALL

echo 'TPU Host Freeze pip'
pip freeze
echo
echo
