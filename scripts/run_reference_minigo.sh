SEED=1
OUT_DIR=/root/minigo_result
mkdir -p $OUT_DIR
cd /root/reference/reinforcement/minigo
bash loop_main.sh params/final.json $SEED

