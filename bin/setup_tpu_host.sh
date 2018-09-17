#!/bin/bash

set -e 

sudo pip3 install tf-nightly
sudo pip3 install --upgrade oauth2client
sudo pip3 install --upgrade google-api-python-client
sudo pip3 install google-cloud

echo 'TPU Host Freeze pip'
pip freeze
echo 'TPU Host Freeze pip3'
pip3 freeze
