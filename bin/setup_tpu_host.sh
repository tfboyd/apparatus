#!/bin/bash

set -e 

sudo pip install tf-nightly
sudo pip install --upgrade oauth2client
sudo pip install --upgrade google-api-python-client

pip show google-cloud
