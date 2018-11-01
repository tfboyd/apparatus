#!/bin/bash

set -e

pip install pyasn1==0.4.1

cd tpu
##git revert 4a460cf4574a676c4750f99c5b4fa1531669f60d
##git checkout 2e53520c6231f7e72ec84b31303e185b92aac3bd
#
## Check out a known good commit on October 25th
#git checkout 14f0811421fe135e375414a7bda52b2b0f8bc94f
#
## Cherry pick the MLPerf logging commit
## Add remaining MLPerf L2 compliance log for transformer. Also update t…
#git cherry-pick 94d8c03f30357f9b37acddf449b1bfa9c7a8d253

python setup.py install

#sudo pip install tensor2tensor 
