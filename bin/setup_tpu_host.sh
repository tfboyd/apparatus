#!/bin/bash

set -e 

sudo apt-get update
sudo apt-get install -y python3
sudo apt-get install python3.4-venv
sudo pip install --upgrade pip
sudo pip3 install --upgrade pip
sudo pip install pyyaml
sudo pip3 install tf-nightly
sudo pip3 install --upgrade oauth2client
sudo pip3 install --upgrade google-api-python-client
sudo pip3 install google-cloud

echo 'TPU Host Freeze pip'
pip freeze
echo
echo
echo
echo 'TPU Host Freeze pip3'
pip3 freeze
