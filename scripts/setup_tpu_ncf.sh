#!/bin/bash

set -e


cp tpu/models/experimental/ncf/ncf_main.py .


rm -rf /tmp/tpu_ncf_env
virtualenv /tmp/tpu_ncf_env
source /tmp/tpu_ncf_env/bin/activate

pip install -r models/official/requirements.txt
TF_TO_INSTALL=${MLP_TF_PIP_LINE:-tf-nightly}
pip install $TF_TO_INSTALL

pip install --upgrade oauth2client
pip install --upgrade google-api-python-client
pip install google-cloud

