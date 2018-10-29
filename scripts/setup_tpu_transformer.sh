#!/bin/bash

set -e

pip install pyasn1==0.4.1

cd tpu
# git revert 4a460cf4574a676c4750f99c5b4fa1531669f60d

python setup.py install

#sudo pip install tensor2tensor 
