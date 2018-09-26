#!/bin/bash

set -e
set -o pipefail

COMMAND_FILE=$1
BENCHMARK_DIR=$2
INPUT_DIR=$3
OUTPUT_DIR=$4

SECONDS=`date +%s`
HOST=`hostname`

OUTPUT_SUBDIR=$OUTPUT_DIR/${HOST}_${SECONDS}

python3 bin/bake_benchmark.py $COMMAND_FILE $BENCHMARK_DIR $INPUT_DIR $OUTPUT_SUBDIR



pushd $BENCHMARK_DIR
bash bootstrap.sh
bash setup.sh
bash main.sh 2>&1 | tee output.txt
popd

python3 bin/roguezero_report.py $BENCHMARK_DIR/
