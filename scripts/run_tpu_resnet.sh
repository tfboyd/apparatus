
HOST=`hostname`
SECONDS=`date +%s`
python3 tpu/models/official/resnet/resnet_main.py --tpu=$MLP_TPU_NAME --data_dir=$MLP_PATH_GCS_IMAGENET --model_dir=gs://garden-model-dirs/resnet/tpu_resnet_test/${HOST}-${SECONDS} --train_batch_size=1024 --iterations_
per_loop=112603 --mode=train --eval_batch_size=1000 --tpu_zone=us-central1-b --num_cores=8 --train_steps=112603

