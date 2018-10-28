#!/bin/bash

set -e

pip install pyasn1==0.4.1

cd tpu

sudo python3 setup.py install 

#sudo pip install tensor2tensor 
