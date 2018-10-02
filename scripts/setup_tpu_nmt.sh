#!/bin/bash

set -e

sudo apt-get update
sudo apt-get install -y python3-tk unzip

sudo pip install --upgrade pip

sudo pip install sacrebleu
sudo pip2 install sacrebleu

