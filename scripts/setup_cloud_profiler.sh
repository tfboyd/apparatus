#!/bin/bash

set -e

echo "Setting up cloud_tpu_profiler"

sudo apt-get update && \
sudo apt-get install build-essential software-properties-common -y && \
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
sudo apt-get update && \
sudo apt-get install gcc-snapshot -y && \
sudo apt-get update && \
sudo apt-get install gcc-6 g++-6 -y && \
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6 && \
sudo apt-get install gcc-4.8 g++-4.8 -y && \
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8;
sudo update-alternatives --set gcc /usr/bin/gcc-6

yes | sudo dpkg --configure -a
sudo apt-get install -f -y

gcc -v

sudo apt-get install python3-pip
sudo pip3 install -U google-api-python-client oauth2client
sudo pip3 install cloud-tpu-profiler==1.12

#gsutil cp gs://garden-model-dirs/utils/tpu_profiler_pip/cloud_tpu_profiler-1.12.0-py3-none-any.whl .
#sudo pip3 install cloud_tpu_profiler-1.12.0-py3-none-any.whl

