#!/bin/bash

sudo apt-get install -y nvidia-docker2
sudo pip install pyyaml
sudo pip3 install pyyaml

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


