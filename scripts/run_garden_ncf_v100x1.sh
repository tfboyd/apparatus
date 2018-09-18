set -e

cd /root/garden/official/recommendation/

# run benchmark

# Quality of 0.2 is roughly a few hours of work
# 0.749 is the final target quality

echo `pwd`

pip3 install -r ../requirements.txt



DATASET="ml-20m"
DATA_DIR="/output/data"

export PYTHONPATH="$PYTHONPATH:/root/garden"

python3 ../datasets/movielens.py --data_dir ${DATA_DIR} --dataset ${DATASET}




# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)
echo "STARTING TIMING RUN AT $start_fmt"

MODEL_DIR=/output/model_dir
mkdir $MODEL_DIR

# Note: The hit rate threshold has been set to 0.62 rather than the MLPerf 0.635
#       The reason why the TF implementation does not reach 0.635 is still unknown.
python3 ncf_main.py --model_dir ${MODEL_DIR} \
									 --data_dir ${DATA_DIR} \
									 --dataset ${DATASET} --hooks "" \
									 --num_gpus 1 \
									 --clean \
									 --train_epochs 100 \
									 --batch_size 2048 \
									 --eval_batch_size 65536 \
									 --learning_rate 0.0005 \
									 --layers 256,256,128,64 --num_factors 64 \
									 --hr_threshold 0.635 \
                   --ml_perf



# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="resnet"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"
