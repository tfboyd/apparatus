#!/bin/bash
set -e
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt-get upgrade python3
# sudo apt install docker-ce -y
sudo apt install docker-ce=18.06.0~ce~3-0~ubuntu -y --allow-downgrades
sudo apt-get install -y nvidia-docker2
sudo pip install pyyaml
sudo pip3 install --upgrade google-api-python-client paramiko google-cloud google-cloud-bigquery
sudo service docker start
sudo pkill -SIGHUP dockerd
sudo apt install -y bridge-utils
sudo service docker stop
sleep 1;
sudo iptables -t nat -F
sleep 1;
sudo ifconfig docker0 down
sleep 1;
sudo brctl delbr docker0
sleep 1;
sudo service docker start
