#!/bin/bash

set -e

mkdir minigo_data
gsutil cp -r gs://mlp_resources/benchmark_data/minigo minigo_data

git clone https://bitfort:$MLP_GITHUB_KEY@github.com/chsigg/mlperf.git --branch mlperf mlperf/reference
git clone https://bitfort:$MLP_GITHUB_KEY@github.com/chsigg/minigo.git --branch mlperf tensorflow/minigo

