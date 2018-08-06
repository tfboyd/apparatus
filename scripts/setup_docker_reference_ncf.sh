#!/bin/bash
# Set working directory
set -e 

cd /root

apt-get install -y git make build-essential libssl-dev zlib1g-dev libbz2-dev \
                       libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
                       xz-utils tk-dev cmake unzip

# pyenv Install
git clone https://github.com/pyenv/pyenv.git .pyenv

export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Install Anaconda
PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install anaconda3-5.0.1
pyenv rehash
pyenv global anaconda3-5.0.1

# Install PyTorch Requirements
export CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"
conda install -y numpy pyyaml mkl mkl-include setuptools cmake cffi typing
conda install -c pytorch -y magma-cuda90

# Install PyTorch
mkdir github
cd github
git clone --recursive https://github.com/pytorch/pytorch
cd pytorch
git checkout v0.4.0
git submodule update --init
python setup.py clean
python setup.py install

# Install ncf-pytorch
#cd /root
#mkdir ncf
#cd ncf
#WORKDIR /mlperf/ncf
## TODO: Change to clone github repo
#ADD . /mlperf/ncf
#RUN pip install -r requirements.txt
#WORKDIR /mlperf/experiment
#ENTRYPOINT ["/mlperf/ncf/run_and_time.sh"]
