#!/bin/bash

set -e


git clone https://github.com/tensorflow/models.git garden

# TODO(robieta): remove once merged
pushd garden
git checkout feat/ncf_actual_mlperf_logging
popd
