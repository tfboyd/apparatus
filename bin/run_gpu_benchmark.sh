
set -e

# Install a few libraries needed by the setup scripts
# Assuming python3/pip is already installed and nvidia-docker2
sudo apt-get update
sudo apt-get -y --no-install-recommends install mdadm
sudo pip3 install pyyaml google-api-python-client google-cloud google-cloud-bigquery

CMD_FILE=$1
DIR=$2

rm -rf $DIR
cd lib
python -m apparatus.preflight.preflight "$@"

(cd ../$DIR/ && bash ./main.sh)

