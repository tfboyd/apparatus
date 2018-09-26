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
    if os.system('cp ./{} {}/setup.sh'.format(bench_def['setup_script'], bench_dir)) != 0:
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

export MLP_GCS_MODEL_DIR=gs://garden-model-dirs/tests
export MLP_TPU_TF_VERSION=nightly
export MLP_GCP_HOST=`hostname`
export MLP_GCP_ZONE=`gcloud compute instances list $MLP_GCP_HOST --format 'csv[no-heading](zone)' 2>/dev/null`
export MLP_TPU_NAME=${MLP_GCP_HOST}_TPU

export MLP_PATH_GCS_IMAGENET=gs://garden-imgnet/imagenet/combined
export MLP_PATH_GCS_TRANSFORMER=gs://mlp_resources/benchmark_data/transformer

# gcloud compute instances list $MLP_GCP_HOST --format 'csv[no-heading](zone)'

echo MLP_TPU_TF_VERSION $MLP_TPU_TF_VERSION
echo MLP_GCP_HOST $MLP_GCP_HOST
echo MLP_GCP_ZONE $MLP_GCP_ZONE
echo MLP_TPU_NAME $MLP_TPU_NAME

gcloud auth list



for x in {0..255}; do
echo gcloud alpha compute tpus create $MLP_TPU_NAME --range=10.255.$x.0/29 --version=$MLP_TPU_TF_VERSION --network=default --accelerator-type=v2-8 --zone $MLP_GCP_ZONE
gcloud alpha compute tpus create $MLP_TPU_NAME --range=10.255.$x.0/29 --version=$MLP_TPU_TF_VERSION --network=default --accelerator-type=v2-8 --zone $MLP_GCP_ZONE 2>&1 | tee /tmp/create_tpu_log.txt


if grep -q "Try a different range." /tmp/create_tpu_log.txt; then
  # In this case, the network address is taken adn we should re-try this action, incrementing x
  echo "Trying a different range.";
else
  break
fi

done

# Give the TPU a minute to get 'HEALTHY'
echo "Sleeping for 5 mins to let TPU get healthy"
sleep 300

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


def bake_docker(bench_def, bench_dir):
    if os.system('mkdir -p {}'.format(bench_dir)) != 0:
        return False
    if os.system('cp ./{} {}/run_helper.sh'.format(bench_def['main_script'], bench_dir)) != 0:
        print('Failed to copy run_helper.')
        return False
    if os.system('cp ./scripts/{} {}/docker_setup.sh'.format(bench_def['docker_vars']['DOCKER_SCRIPT'], bench_dir)) != 0:
        print('Failed to copy docker_setup.')
        return False
    if os.system('cp ./{} {}/bootstrap.sh'.format(bench_def['bootstrap_script'], bench_dir)) != 0:
        print('Failed to copy bootstrap.')
        return False

    # Move into benchmark directory
    #cwd = os.getcwd()
    os.chdir(bench_dir)

    #RUN apt-get install -y python3.6
    #RUN apt-get install -y python3-pip
    #
    #
    #RUN pip3 install --upgrade pip
    #RUN pip3 install pyyaml

    with open('Dockerfile', 'w') as f:
        f.write('''
FROM {docker_base}

WORKDIR /root
ENV HOME /root

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y build-essential git
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update
ADD . /root

RUN bash /root/docker_setup.sh

ENTRYPOINT ["/bin/bash"]
'''.format(docker_base=bench_def['docker_vars']['DOCKER_FROM']))

    with open('main.sh', 'w') as f:
        f.write('''
#!/bin/bash
set -e
sudo nvidia-docker build . -t foo
sudo nvidia-docker run -t foo:latest /root/run_helper.sh 2>&1 | tee output.txt
''')
    return True


def main():
    if len(sys.argv) < 3:
        print('usage: BENCHMARK_FILE BENCHMARK_DIR INPUT_DIR OUTPUT_DIR')
        sys.exit(1)

    benchmark_file = sys.argv[1]
    benchmark_dir = sys.argv[2]
    input_dir = None
    output_dir = None
    # input_dir = sys.argv[3]
    # output_dir = sys.argv[4]


    with open(benchmark_file) as f:
        bench_def = yaml.load(f)

    if 'docker_vars' in bench_def:
        if not bake_docker(bench_def, benchmark_dir):
            print('Exiting with error.')
            sys.exit(1)
    elif not bake_tpu(bench_def, benchmark_dir, input_dir, output_dir):
        print('Exiting with error.')
        sys.exit(1)


if __name__ == '__main__':
  main()
