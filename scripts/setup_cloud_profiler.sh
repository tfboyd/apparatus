#!/bin/bash

set -e

echo "Setting up cloud_tpu_profiler"

export DEBIAN_FRONTEND=noninteractive
apt-get update && \
apt-get install build-essential software-properties-common -y && \
apt-get update && \
add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
apt-get update && \
apt-get install gcc-snapshot -y && \
apt-get update && \
apt-get install gcc-6 g++-6 -y && \
apt-get install gcc-4.8 g++-4.8 -y && \
apt-get upgrade -y libstdc++6

pip install -U google-api-python-client oauth2client
pip install cloud-tpu-profiler==1.12

