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

echo "switching to virtual environment"
source ${RUN_VENV}/bin/activate

pushd $BENCHMARK_DIR

printf "\n\n\nCalling: bootstrap.sh\n"
bash bootstrap.sh

printf "\n\n\nCalling: setup.sh\n"
bash setup.sh

printf "\n\n\nCalling: main.sh\n"
bash main.sh 2>&1 | tee output.txt
popd

printf "\n\n\nCalling: bin/roguezero_report.py\n"
python3 bin/roguezero_report.py $BENCHMARK_DIR/
