#!/bin/bash

set -e

pip install pyasn1==0.4.1

cd tpu
git checkout 14f0811421fe135e375414a7bda52b2b0f8bc94f

python setup.py install

#sudo pip install tensor2tensor 
