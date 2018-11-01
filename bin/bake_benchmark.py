#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import os
import sys
import yaml
import subprocess
import time


DEFAULT_VARS = {
        'MLP_TF_PIP_LINE': 'tf-nightly',
        'MLP_CIDR_SIZE': '29',
        'MLP_TPU_SIDECAR': 'N'
}


def get_env(name):
    if name not in os.environ:
        return DEFAULT_VARS[name]
    return os.environ[name]

TPU_MAIN = '''#!/bin/bash
set -e

export MLP_TPU_TF_VERSION=__TPU_TF_VERSION__
export MLP_TF_PIP_LINE=__TF_PIP_LINE__
export MLP_CIDR_SIZE=__CIDR_SIZE__
export MLP_TPU_VERSION=__TPU_VERSION__
export MLP_TPU_SIDECAR=__TPU_SIDECAR__
export BENCHMARK=__BENCHMARK__

SECONDS=`date +%s`
DAY_OF_MONTH=`date -d "$D" '+%d'`
export MLP_GCP_HOST=`hostname`
export MLP_GCS_MODEL_DIR=gs://garden-model-dirs/tests/${MLP_GCP_HOST}-${SECONDS}
export MLP_GCP_ZONE=`gcloud compute instances list $MLP_GCP_HOST --format 'csv[no-heading](zone)' 2>/dev/null`
export MLP_TPU_NAME=${MLP_GCP_HOST}_TPU_${DAY_OF_MONTH}

export MLP_TPU_SIDECAR_NAME=${MLP_GCP_HOST}_TPU_SIDECAR_${DAY_OF_MONTH}

export MLP_PATH_GCS_IMAGENET=gs://garden-imgnet/imagenet/combined
export MLP_PATH_GCS_TRANSFORMER=gs://mlp_resources/benchmark_data/transformer_v2
export MLP_PATH_GCS_SSD=gs://mlp_resources/benchmark_data/ssd_coco
# Note: needs tailing /
export MLP_PATH_GCS_NMT=gs://mlp_resources/benchmark_data/nmt/wmt16_de_en/
export MLP_PATH_GCS_NCF=gs://mlp_resources/benchmark_data/ncf_tpu

export MLP_GCS_RESNET_CHECKPOINT=gs://mlp_resources/benchmark_data/resnet34_ssd_checkpoint

# TODO(robieta): comment this out. Other people might not want us to be able to SSH into their boxes. (even though we're so friendly...)
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7JfyEyZBCxObm9FSxqBh86n/jVAKxAC0gaHZlilWf7BwUe28P7UNflpK6Qk0z0lVRnYaCOFGc8fLK4K/oQYHzU+UdD2j/BzvWFUh2YyA/ixLvXDYWM/PahHdRDGv/Lykchl6s95sXwi9Gwsyo9WqKy8ea7nJ6uwbyzvX7l+kqyuSbbX6Sb8xPJPZSTedx0rxiuCRwUoWeJo4c9e3cyF79KFcY2WaOVMsijP4mZbwkD9AkR0XvPSCIVWytif77vebQNsulO8F/tR9hO8iAFPn2pdJudmBadURF4UUoOesr/vXTqHDLnhopBjCNoSbrFM3HOCuIUdZrbVHYpJu261VB taylorrobie@taylorrobie.mtv.corp.google.com" >> ~/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8wuSBRh+Lu6Yc//WSLwwdtb5xBmW1juDrkeXBpxp05Y7nYCpFKGFSp6xBAuIimU4Anul9yAupGrMfGavhHrCAmCFVb/UyoaX+6tszZ0NGgRcH7OL6niH9GgLYyYpL+G7zJrAuC/eP9ck0Q70oPY9SqTDDJ5b5yR07bnK/IWZzArTtDCJxhsFiHVfU2DNhM54eqGpHt4jcqqRXCbT/8WpC5rPMhQYBtOTT2OLlXtm9ml0qaX/4ItWQZK/fx7y8YtlHzG0Mn91tL4lFqtAd7PMuQ0cPjMuNRePqeaeNlws7A80y8KV8niF8Yv/CfrnCoKYFx98/fhqiv2Ot0X6fXOZf qiuminxu@qiuminxu.svl.corp.google.com" >> ~/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDrSkVkjmlqshbLgZ4OxN3dQR+4C2qFnma85KAZY4D5sRDz5iSQ7OEmz9piDfTd/J/4UIaerb4s5mXveJkQvveCXTMox8A0L5ipu/Tcl0krop08QPcWpZT4rhqUCRv3yhIe3vJpeXuj55RbCy2+Jr/mfHkVjVBv6G0MJ6MXx77FBuQNe/lrBngtbMg7UZ30ngH+BxSd5T1J0G3g3f/EVIYFCSejx+9bWkIlAZhuuss84fry+elkLqEsRclq1X8gDZ9pEgAaj7ImTr+6etPjamY76/AdXH65G+AOzZ7W/H4KINWS08mqLQf5E8B32LHMgPAH5dNGGinlfSzMD6+eloWnwo5qrxwCoQIVq+A3gW47j3qFpTEQH0zWGbdXpGqAinuLp9JZD3ImbUyocK5zXPbjOnk4F74Oe2ehD4Nxd1zeu8kOOMy7yYVdutY1p8jpHA3uHk3F0z/e66tigD8U+vaIXo8ggSL4VMWlY8EKpmUy077DnNLO+L1uHQrJRSLmgmdvjO85kEuNaQEBvl1LckbvIfkm6sdJrYZdCUdw+yfEQLH1Gks0aHSMEcTBmgs6AucGqUCrExfJI4tLTmnjHY9IHTQx0ZH8BoOiMVeMKheGsttfVXKWpKfRA5cETxv5RErikRQXJ6UIrT6Z82Awa1Gvdnmvl8jhuXpnHC/l2le9Pw== toddw@google.com" >> ~/.ssh/authorized_keys

# gcloud compute instances list $MLP_GCP_HOST --format 'csv[no-heading](zone)'

echo MLP_TPU_TF_VERSION $MLP_TPU_TF_VERSION
echo MLP_GCP_HOST $MLP_GCP_HOST
echo MLP_GCP_ZONE $MLP_GCP_ZONE
echo MLP_TPU_NAME $MLP_TPU_NAME

TPU_PREEMPT=""
if [[ $MLP_TPU_VERSION =~ "32"$ ]]; then
  TPU_PREEMPT="--preemptible"
fi
if [[ $MLP_TPU_VERSION =~ "128"$ ]]; then
  TPU_PREEMPT=""
fi
if [[ $MLP_TPU_VERSION =~ "512"$ ]]; then
  TPU_PREEMPT="--preemptible"
fi

gcloud auth list


for x in {0..255}; do
BASE_IP=$((1 + RANDOM % 255))
echo gcloud alpha compute tpus create $MLP_TPU_NAME --range=10.$BASE_IP.$x.0/$MLP_CIDR_SIZE $TPU_PREEMPT --version=$MLP_TPU_TF_VERSION --network=default --accelerator-type=$MLP_TPU_VERSION --zone $MLP_GCP_ZONE
gcloud alpha compute tpus create $MLP_TPU_NAME --range=10.$BASE_IP.$x.0/$MLP_CIDR_SIZE $TPU_PREEMPT --version=$MLP_TPU_TF_VERSION --network=default --accelerator-type=$MLP_TPU_VERSION --zone $MLP_GCP_ZONE 2>&1 | tee /tmp/create_tpu_log.txt

STATUS=$?

if grep -q "Try a different range" /tmp/create_tpu_log.txt; then
  # In this case, the network address is taken adn we should re-try this action, incrementing x
  echo "Trying a different range...";
elif grep -q "CIDR" /tmp/create_tpu_log.txt; then
  # In this case, the network address is taken adn we should re-try this action, incrementing x
  echo "Trying a different range (CIDR error)...";
elif grep -q "Invalid" /tmp/create_tpu_log.txt; then
  # In this case, the network address is taken adn we should re-try this action, incrementing x
  echo "Trying a different range...";
else
  break
  if [ $? -ne 0 ]
  then
     echo "Failed to start TPU"
     exit 1
 fi
fi
done

# Start the TPU Sidecar
if [[ $MLP_TPU_SIDECAR =~ "Y"$ ]]; then
    for x in {0..255}; do
    BASE_IP=$((1 + RANDOM % 255))
    echo gcloud alpha compute tpus create $MLP_TPU_SIDECAR_NAME --range=10.$BASE_IP.$x.0/29 --version=$MLP_TPU_TF_VERSION --network=default --accelerator-type=v2-8 --zone $MLP_GCP_ZONE
    gcloud alpha compute tpus create $MLP_TPU_SIDECAR_NAME --range=10.$BASE_IP.$x.0/29 --version=$MLP_TPU_TF_VERSION --network=default --accelerator-type=v2-8 --zone $MLP_GCP_ZONE 2>&1 | tee /tmp/create_tpu_log.txt

    STATUS=$?

    if grep -q "Try a different range" /tmp/create_tpu_log.txt; then
      # In this case, the network address is taken adn we should re-try this action, incrementing x
      echo "Trying a different range...";
    elif grep -q "CIDR" /tmp/create_tpu_log.txt; then
      # In this case, the network address is taken adn we should re-try this action, incrementing x
      echo "Trying a different range (CIDR error)...";
    elif grep -q "Invalid" /tmp/create_tpu_log.txt; then
      # In this case, the network address is taken adn we should re-try this action, incrementing x
      echo "Trying a different range...";
    else
      break
      if [ $? -ne 0 ]
      then
         echo "Failed to start TPU"
         exit 1
     fi
    fi
    done
fi

set +e

pip install mlperf_compliance==0.0.10
if [ $BENCHMARK ]; then
  echo "Clearing caches. (Fresh TPUs have already been started.)"
  sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
  STAT=$?
  if [ $STAT -eq 0 ]; then
    echo "Cache clear successful."
    python -c "import mlperf_compliance;mlperf_compliance.mlperf_log.${BENCHMARK}_print(key='run_clear_caches')"
  fi
fi


# Place certain environment variables in a file in /tmp to make it easier to SSH and collect traces.
PROFILER_PREP="/tmp/prep_profiler.sh"
echo "source ${RUN_VENV}/bin/activate" >> ${PROFILER_PREP}
echo "export PATH=\"\$PATH:\`python -m site --user-base\`/bin\"" >> ${PROFILER_PREP}
echo "export MLP_GCP_HOST=${MLP_GCP_HOST}" >> ${PROFILER_PREP}
echo "export MLP_GCS_MODEL_DIR=${MLP_GCS_MODEL_DIR}" >> ${PROFILER_PREP}
echo "export MLP_GCP_ZONE=${MLP_GCP_ZONE}" >> ${PROFILER_PREP}
echo "export MLP_TPU_NAME=${MLP_TPU_NAME}" >> ${PROFILER_PREP}
echo "export MLP_TPU_SIDECAR_NAME=${MLP_TPU_SIDECAR_NAME}" >> ${PROFILER_PREP}

sudo bash upgrade_gcc.sh
export PATH="$PATH:`python3 -m site --user-base`/bin"


bash run_helper.sh

BENCHMARK_EXIT_CODE=$?

set -e

echo  gcloud alpha compute tpus delete $MLP_TPU_NAME --zone $MLP_GCP_ZONE
yes | gcloud alpha compute tpus delete $MLP_TPU_NAME --zone $MLP_GCP_ZONE

# Stop the TPU Sidecar
if [[ $MLP_TPU_SIDECAR =~ "Y"$ ]]; then
    echo  gcloud alpha compute tpus delete $MLP_TPU_SIDECAR_NAME --zone $MLP_GCP_ZONE
    yes | gcloud alpha compute tpus delete $MLP_TPU_SIDECAR_NAME --zone $MLP_GCP_ZONE
fi

exit $BENCHMARK_EXIT_CODE
'''


def bake_tpu(bench_def, bench_dir, input_dir, output_dir):
    if os.system('mkdir -p {}'.format(bench_dir)) != 0:
        return False
    if os.system('cp ./{} {}/bootstrap.sh'.format(bench_def['bootstrap_script'], bench_dir)) != 0:
        return False
    if os.system('cp ./{} {}/setup.sh'.format(bench_def['setup_script'], bench_dir)) != 0:
        return False
    if os.system('cp ./{} {}/upgrade_gcc.sh'.format("scripts/upgrade_gcc.sh", bench_dir)) != 0:
        return False
    if os.system('cp ./{} {}/run_helper.sh'.format(bench_def['main_script'], bench_dir)) != 0:
        return False
    cwd = os.getcwd()
    os.chdir(bench_dir)
    if os.system('git clone {} {}'.format(bench_def['github_repo'], bench_def['local_repo_name'], bench_def['github_repo'])) != 0:
        return False
    
    main_sh = TPU_MAIN.replace('__TPU_TF_VERSION__', get_env('MLP_TPU_TF_VERSION'))
    main_sh = main_sh.replace('__TF_PIP_LINE__', get_env('MLP_TF_PIP_LINE'))
    main_sh = main_sh.replace('__CIDR_SIZE__', get_env('MLP_CIDR_SIZE'))
    main_sh = main_sh.replace('__TPU_VERSION__', get_env('MLP_TPU_VERSION'))
    main_sh = main_sh.replace('__TPU_SIDECAR__', get_env('MLP_TPU_SIDECAR'))
    main_sh = main_sh.replace('__BENCHMARK__', bench_def.get('benchmark', ''))

    with open('main.sh', 'w') as f:
        f.write(main_sh)
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
    if os.system('cp ./{} {}/internal_download_data.sh'.format(bench_def['download_data_script'], bench_dir)) != 0:
        print('Failed to copy data_download.')
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
set -o pipefail

#MLP_HOST_DATA_DIR=/tmp/mlp_data
MLP_HOST_OUTPUT_DIR=`pwd`/output

mkdir -p $MLP_HOST_DATA_DIR
mkdir -p $MLP_HOST_OUTPUT_DIR

bash internal_download_data.sh $MLP_HOST_DATA_DIR

sudo nvidia-docker build . -t foo
sudo nvidia-docker run -v ${MLP_HOST_DATA_DIR}:/data -v ${MLP_HOST_OUTPUT_DIR}:/output -v /proc:/host_proc -t foo:latest /root/run_helper.sh 2>&1 | tee output.txt
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
