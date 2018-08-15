set -e

# start timing
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)
echo "STARTING TIMING RUN AT $start_fmt"


# run benchmark

seed=1

echo "running benchmark with seed $seed"
# The termination quality is set in params/final.json. See RAEDME.md.

mkdir -p /research/results/minigo/final/
cd minigo
cat <<EOF > params/smoke.json
{
  "MAX_GAMES_PER_GENERATION": 20,
  "BASE_DIR" : "$HOME/results/minigo/final/",
  "HOLDOUT_PCT": 0,
  "NUM_MAIN_ITERATIONS": 10000,
  "BOARD_SIZE": 9,
  "SHUFFLE_BUFFER_SIZE": 100000,
  "EXAMPLES_PER_RECORD": 50000,
  "WINDOW_SIZE": 2000000,
  "DUMMY_MODEL": false,
  "NUM_PARALLEL_SELFPLAY": 8,
  "EVAL_GAMES_PER_SIDE": 1,
  "EVAL_WIN_PCT_FOR_NEW_MODEL": 0.55,
  "EVALUATE_MODELS": true,
  "EVALUATE_PUZZLES": true,
  "TRIES_PER_PUZZLE": 5,
  "SP_READOUTS": 200,
  "TERMINATION_ACCURACY": 0.01
}
EOF

bash loop_main.sh params/smoke.json $seed


sleep 3
ret_code=$?; if [[ $ret_code != 0 ]]; then exit $ret_code; fi


# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result
result=$(( $end - $start ))
result_name="reinforcement"


echo "RESULT,$result_name,$seed,$result,$USER,$start_fmt"
