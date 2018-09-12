#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os
import sys
import yaml
import subprocess
import time



def bake_tpu(bench_def, bench_dir, input_dir, output_dir):
    if os.system('mkdir -p {}'.format(bench_dir)) != 0:
        return False
    if os.system('cp ./{} {}/run_helper.sh'.format(bench_def['main_script'], bench_dir)) != 0:
        return False
    cwd = os.getcwd()
    os.chdir(bench_dir)
    if os.system('git clone {} {}'.format(bench_def['github_repo'], bench_def['local_repo_name'], bench_def['github_repo'])) != 0:
        return False

    with open('main.sh', 'w') as f:
        f.write('''#!/bin/bash
set -e

export MLP_TPU_TF_VERSION=nightly
export MLP_GCP_HOST=`hostname`
export MLP_GCP_ZONE=`gcloud compute instances list $MLP_GCP_HOST --format 'csv[no-heading](zone)' 2>/dev/null`
export MLP_TPU_NAME=${HOST}_TPU

export MLP_PATH_GCS_IMAGENET=gs://garden-imgnet/imagenet/combined/

echo MLP_TPU_TF_VERSION $MLP_TPU_TF_VERSION
echo MLP_GCP_HOST $MLP_GCP_HOST
echo MLP_GCP_ZONE $MLP_GCP_ZONE
echo MLP_TPU_NAME $MLP_TPU_NAME

echo gcloud alpha compute tpus create $MLP_TPU_NAME --range=10.123.45.0/29 --version=$MLP_TPU_TF_VERSION --network=default --accelerator-type=v2-8 --zone $MLP_GCP_ZONE

gcloud alpha compute tpus create $MLP_TPU_NAME --range=10.123.45.0/29 --version=$MLP_TPU_TF_VERSION --network=default --accelerator-type=v2-8 --zone $MLP_GCP_ZONE


set +e

bash run_helper.sh

BENCHMARK_EXIT_CODE=$?

set -e

echo  gcloud alpha compute tpus delete $MLP_TPU_NAME --zone $MLP_GCP_ZONE
yes | gcloud alpha compute tpus delete $MLP_TPU_NAME --zone $MLP_GCP_ZONE

exit $BENCHMARK_EXIT_CODE
''')
    os.chdir(cwd)
    return True



def main():
    if len(sys.argv) < 3:
        print('usage: BENCHMARK_FILE BENCHMARK_DIR INPUT_DIR OUTPUT_DIR')
        sys.exit(1)

    benchmark_file = sys.argv[1]
    benchmark_dir = sys.argv[2]
    input_dir = None
    output_dir = None


    with open(benchmark_file) as f:
        bench_def = yaml.load(f)

    if not bake_tpu(bench_def, benchmark_dir, input_dir, output_dir):
        print('Exiting with error.')
        sys.exit(1)


if __name__ == '__main__':
  main()
