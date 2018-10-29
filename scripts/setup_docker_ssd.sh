#!/bin/bash
# Set working directory
set -e

apt-get update
echo 'Installing build deps for python matloplib'
apt-get -y install python3-matplotlib

