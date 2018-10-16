#!/bin/bash

BENCH=$1
TS=`date +%s`.000

export PREFIX=":::MLPv0.5.0 $BENCH $TS (info.sh:0) misc_info:"


APT=`apt list --installed | grep -v Listing`

while read -r line; do
  echo "$PREFIX {'key': 'apt', 'value': '$line'}"
done <<< "$APT"

PIP=`pip freeze`

while read -r line; do
  echo "$PREFIX {'key': 'pip', 'value': '$line'}"
done <<< "$PIP"


PIP=`pip2 freeze`

while read -r line; do
  echo "$PREFIX {'key': 'pip2', 'value': '$line'}"
done <<< "$PIP"

PIP=`pip3 freeze`

while read -r line; do
  echo "$PREFIX {'key': 'pip3', 'value': '$line'}"
done <<< "$PIP"



PY=`python --version 2>&1`
echo "$PREFIX {'key': 'python_version', 'value': '$PY'}"

PY=`python2 --version 2>&1`
echo "$PREFIX {'key': 'python2_version', 'value': '$PY'}"

PY=`python3 --version 2>&1`
echo "$PREFIX {'key': 'python3_version', 'value': '$PY'}"


TF=`python -c 'from __future__ import print_function; import tensorflow; print(tensorflow.__version__)'`
echo "$PREFIX {'key': 'python_tensorflow_version', 'value': '$TF'}"
TF=`python2 -c 'from __future__ import print_function; import tensorflow; print(tensorflow.__version__)'`
echo "$PREFIX {'key': 'python2_tensorflow_version', 'value': '$TF'}"
TF=`python3 -c 'from __future__ import print_function; import tensorflow; print(tensorflow.__version__)'`
echo "$PREFIX {'key': 'python3_tensorflow_version', 'value': '$TF'}"


W=`which pip`
echo "$PREFIX {'key': 'which_pip', 'value': '$W'}"
W=`which pip2`
echo "$PREFIX {'key': 'which_pip2', 'value': '$W'}"
W=`which pip3`
echo "$PREFIX {'key': 'which_pip3', 'value': '$W'}"
W=`which python`
echo "$PREFIX {'key': 'which_python', 'value': '$W'}"
W=`which python2`
echo "$PREFIX {'key': 'which_python2', 'value': '$W'}"
W=`which python3`
echo "$PREFIX {'key': 'which_python3', 'value': '$W'}"
