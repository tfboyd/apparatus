#!/bin/bash

set -e

pip install pyasn1==0.4.1

cd tpu

python setup.py install

#sudo pip install tensor2tensor 
