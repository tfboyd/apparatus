#!/bin/bash

set -e

sudo pip3 install pyasn1==0.4.1

cd tpu

sudo python3 setup.py install 

#sudo pip install tensor2tensor 
