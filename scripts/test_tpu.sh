#!/bin/bash

set -e

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

python3 test_tpu.py $MLP_TPU_NAME
