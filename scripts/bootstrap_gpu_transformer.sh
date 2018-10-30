#!/bin/bash

set -e

repo="smit-hinsu/tensor2tensor"
git clone https://github.com/${repo}.git t2t

hash=$(git rev-parse HEAD)
echo "Cloned $repo isat $hash"
