#!/bin/bash
set -e

sudo pip3 install --upgrade pip
echo "INSTALLING GOOGLE "
sudo pip3 install google-api-python-client google-cloud google-cloud-bigquery
