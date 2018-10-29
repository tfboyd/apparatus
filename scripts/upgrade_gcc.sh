#!/bin/bash

set -e

echo "Upgrading GCC for cloud_tpu_profiler"

export DEBIAN_FRONTEND=noninteractive
apt-get update && \
apt-get install build-essential software-properties-common -y && \
apt-get update && \
add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
apt-get update && \
apt-get install gcc-snapshot -y && \
apt-get update && \
apt-get install gcc-6 g++-6 -y && \
apt-get install gcc-4.8 g++-4.8 -y && \
apt-get upgrade -y libstdc++6

# Place certain environment variables in a file in /tmp to make it easier to SSH and collect traces.
PROFILER_PREP="/tmp/prep_profiler.sh"
echo "source ${RUN_VENV}/bin/activate" >> ${PROFILER_PREP}
echo "export PATH=\"\$PATH:\`python -m site --user-base\`/bin\"" >> ${PROFILER_PREP}
echo "export MLP_GCP_HOST=${MLP_GCP_HOST}" >> ${PROFILER_PREP}
echo "export MLP_GCS_MODEL_DIR=${MLP_GCS_MODEL_DIR}" >> ${PROFILER_PREP}
echo "export MLP_GCP_ZONE=${MLP_GCP_ZONE}" >> ${PROFILER_PREP}
echo "export MLP_TPU_NAME=${MLP_TPU_NAME}" >> ${PROFILER_PREP}
echo "export MLP_TPU_SIDECAR_NAME=${MLP_TPU_SIDECAR_NAME}" >> ${PROFILER_PREP}
