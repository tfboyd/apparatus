#!/bin/bash

set -e


CMD="""t2t-trainer \
--data_dir=$MLP_PATH_GCS_TRANSFORMER/data/ \
--eval_steps=5 \
--hparams=learning_rate_warmup_steps=4000,pad_batch=true \
--hparams_set=transformer_mlperf_tpu \
--iterations_per_loop=9300 \
--keep_checkpoint_max=10 \
--local_eval_frequency=9300 \
--cloud_tpu_name=$MLP_TPU_NAME \
--model=transformer \
--output_dir=$MLP_GCS_MODEL_DIR/train \
--problem=translate_ende_wmt32k_packed \
--schedule=train_eval_and_decode \
--tpu_num_shards=8 \
--train_steps=20000 \
--use_tpu
--decode_from_file=$MLP_PATH_GCS_TRANSFORMER/wmt14-en-de.src \
--decode_reference=$MLP_PATH_GCS_TRANSFORMER/wmt14-en-de.ref \
--decode_to_file=$MLP_GCS_MODEL_DIR/decode.transformer_mlperf_tpu.translate_ende_wmt32k_packed.2x2_log_1018_2 \
--decode_hparams=batch_size=64,beam_size=4,alpha=0.6,extra_length=50,mlperf_mode=true \
"""


echo $CMD

# start timing 
start=$(date +%s)
start_fmt=$(date +%Y-%m-%d\ %r)

$CMD

# end timing
end=$(date +%s)
end_fmt=$(date +%Y-%m-%d\ %r)
echo "ENDING TIMING RUN AT $end_fmt"


# report result 
result=$(( $end - $start )) 
result_name="transformer"


echo "RESULT,$result_name,0,$result,$USER,$start_fmt"

