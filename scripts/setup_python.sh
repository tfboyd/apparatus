
sudo apt-get update
sudo apt-get install -y python3-pip virtualenv

which python3
python3 --version

virtualenv -p python3 ${RUN_VENV}
pip --version

pip install -r requirements.txt

# Note: this could be over-ridden later
TF_TO_INSTALL=${MLP_TF_PIP_LINE:-tf-nightly}
pip install $TF_TO_INSTALL

echo 'TPU Host Freeze pip'
pip freeze
echo
echo

