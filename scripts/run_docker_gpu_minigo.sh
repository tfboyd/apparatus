SEED=1

OUT_DIR=/root/minigo_result
mkdir -p $OUT_DIR

cd /root
source minigo_env/bin/activate

cd /root/mlperf/reference/reinforcement/tensorflow/

bash ./run_and_time.sh

