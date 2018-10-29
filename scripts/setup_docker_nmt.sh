#!/bin/bash
# Set working directory
set -e

echo Installing Sacrebleu
pip3 install sacrebleu


echo "Cloning moses for data processing"
pushd staging/models/rough/nmt_gpu
git clone https://github.com/moses-smt/mosesdecoder.git "mosesdecoder"
pushd mosesdecoder
git reset --hard 8c5eaa1a122236bbf927bde4ec610906fea599e6
popd
popd

