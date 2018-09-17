#!/bin/bash

set -e 

sudo pip install tf-nightly
sudo pip install --upgrade oauth2client
sudo pip install --upgrade google-api-python-client
sudo pip install google-cloud
sudo pip3 install google-cloud

echo 'TPU Host Freeze pip'
pip freeze
echo 'TPU Host Freeze pip3'
pip3 freeze
