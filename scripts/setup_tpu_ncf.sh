#!/bin/bash

set -e


cp tpu/models/experimental/ncf/ncf_main.py .


sudo pip3 install -r models/official/requirements.txt

sudo pip3 install tf-nightly
