#!/bin/bash

set -e

sudo apt-get update
sudo apt-get install -y python3-tk unzip


rm -rf /tmp/nmt_env
virtualenv -p /usr/bin/python2.7 /tmp/nmt_env

source /tmp/nmt/bin/activate

sudo pip install sacrebleu

