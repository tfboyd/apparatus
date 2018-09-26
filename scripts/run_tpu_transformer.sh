#!/bin/bash

set -e

#--data_dir=$MLP_TRANSFORMER_GCS_DATA/cns/ei-d/home/tpu-perf-team/shibow/transformer/ \
#--decode_to_file=/cns/el-d/home/tpu-perf-team/shibow/rs=6.3/decode.transformer_mlperf_tpu.translate_ende_wmt32k_packed.new_dataset_lb512_wu16000_test \

CMD="t2t-trainer \
	--data_dir=$MLP_PATH_GCS_TRANSFORMER/data/transformer \
	--decode_from_file=$MLP_PATH_GCS_TRANSFORMER/wmt14-en-de.src \
	--decode_hparams=batch_size=64,beam_size=4,alpha=0.6,extra_length=50 \
	--decode_reference=$MLP_PATH_GCS_TRANSFORMER/wmt14-en-de.ref \
	--decode_to_file=$MLP_GCS_MODEL_DIR/ \
	--eval_steps=5 \
	--hparams=batch_size=512,learning_rate_warmup_steps=16000 \
	--hparams_set=transformer_mlperf_tpu \
	--keep_checkpoint_max=10 \
	--local_eval_frequency=1000 \
	--model=transformer \
	--output_dir=$MLP_GCS_MODEL_DIR \
	--problem=translate_ende_wmt32k_packed \
	--rpclog=-1 \
	--schedule=continuous_decode_from_file \
	--train_steps=250000 \
  --cloud_tpu_name=$MLP_TPU_NAME"
echo $CMD

$CMD
