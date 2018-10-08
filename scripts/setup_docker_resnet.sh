
#!/bin/bash
# Set working directory
set -e 

apt-get update
apt-get install wget
apt-get install -y python3.6
apt-get install -y python3-pip
# pip3 install --upgrade pip

apt-get update && apt-get install -y --no-install-recommends ca-certificates
apt-get install -y virtualenv htop
apt-get install -y python-setuptools

#pip3 install --upgrade pip==9.0.3
#pip3 install pyyaml
#pip3 install --upgrade setuptools
#pip3 install absl-py
#pip3 install tensorflow-gpu==1.10.0

#pip3 install -r /root/garden/official/requirements.txt


