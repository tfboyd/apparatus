set -e

cd /root/garden/official/recommendation/

echo `pwd`

pip3 install -r ../requirements.txt

DATASET="ml-20m"
DATA_DIR="/output/data"

export PYTHONPATH="$PYTHONPATH:/root/garden"
export DROP_CACHE_LOC="/host_proc/sys/vm/drop_caches"

python3 ../datasets/movielens.py --data_dir ${DATA_DIR} --dataset ${DATASET}

# start timing
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)
echo "STARTING TIMING RUN AT $start_fmt"

MODEL_DIR=/output/model_dir
mkdir $MODEL_DIR

export COMPLIANCE_FILE="compliance_raw.log"
export STITCHED_COMPLIANCE_FILE="compliance_submission.log"
# TODO(robieta): enable XLA
python3 ncf_main.py \
   --model_dir ${MODEL_DIR} \
   --data_dir ${DATA_DIR} \
   --dataset ${DATASET} --hooks "" \
   --num_gpus 1 \
   --clean \
   --train_epochs 14 \
   --batch_size 98304 \
   --eval_batch_size 100000 \
   --learning_rate=0.00382059 \
   --beta1=0.783529 \
   --beta2=0.909003 \
   --epsilon=1.45439e-07 \
   --layers 256,256,128,64 \
   --num_factors 64 \
   --hr_threshold 0.635 \
   --ml_perf


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"

cat $STITCHED_COMPLIANCE_FILE

# report result
result=$(( $end - $start ))
result_name="ncf"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"
