#!/bin/bash

set -e

sudo apt-get update
sudo apt-get install -y python3-tk unzip

sudo pip3 install --upgrade pip

sudo pip3 install sacrebleu

