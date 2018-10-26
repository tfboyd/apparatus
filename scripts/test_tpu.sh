#!/bin/bash

set -e

sudo pip3 install $MLP_TF_PIP_LINE

# TODO(robieta): formalize if this works.
sudo pip3 install --upgrade "cloud-tpu-profiler>=1.12"
export PATH="$PATH:`python3 -m site --user-base`/bin"

cat << EOF | tee test_tpu.py
import os
import sys
import tensorflow as tf
from tensorflow.contrib import tpu
from tensorflow.contrib.cluster_resolver import TPUClusterResolver

def axy_computation(a, x, y):
  return a * x + y

inputs = [
    3.0,
    tf.ones([3, 3], tf.float32),
    tf.ones([3, 3], tf.float32),
]

tpu_computation = tpu.rewrite(axy_computation, inputs)

tpu_grpc_url = TPUClusterResolver(
    tpu=[sys.argv[1]]).get_master()

with tf.Session(tpu_grpc_url) as sess:
  sess.run(tpu.initialize_system())
  sess.run(tf.global_variables_initializer())
  output = sess.run(tpu_computation)
  print(output)
  sess.run(tpu.shutdown_system())

print('Test Completed Successfully.')
EOF


# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)

# TODO(robieta): formalize if this works.
echo "Writing profile to ${MLP_GCS_MODEL_DIR}"
capture_tpu_profile --tpu=${MLP_TPU_NAME} --logdir=${MLP_GCS_MODEL_DIR} &

python3 test_tpu.py $MLP_TPU_NAME

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"

# report result 
result=$(( $end - $start )) 
result_name="resnet"

echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

