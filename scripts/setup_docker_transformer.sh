#!/bin/bash
# Set working directory
set -e

echo Updating Pip3
#pip3 install --upgrade pip

echo Installing Sacrebleu
# TODO: Why is this installing with pip3 but everything else is python/pip?
pip3 install sacrebleu

# Python 2 packages are to be installed using the module directly.
python -m pip install scipy
python -m pip install pyasn1==0.4.1
python -m pip install rsa==3.1.4

cd t2t

python setup.py install


