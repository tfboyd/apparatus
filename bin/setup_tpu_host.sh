#!/bin/bash

set -e 

sudo pip install tf-nightly
sudo pip install --upgrade oauth2client
sudo pip install --upgrade google-api-python-client
sudo pip install google-cloud
sudo pip3 install google-cloud

pip show google-cloud
pip3 show google-cloud
