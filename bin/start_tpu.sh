



export MLP_TPU_TF_VERSION=nightly
export MLP_GCP_HOST=`hostname`
export MLP_GCP_ZONE=`gcloud compute instances list $MLP_GCP_HOST --format 'csv[no-heading](zone)' 2>/dev/null`
export MLP_TPU_NAME=${MLP_GCP_HOST}__TPU


for x in {0..255}; do
echo gcloud alpha compute tpus create $MLP_TPU_NAME --range=10.255.$x.0/29 --version=$MLP_TPU_TF_VERSION --network=default --accelerator-type=v2-8 --zone $MLP_GCP_ZONE
gcloud alpha compute tpus create $MLP_TPU_NAME --range=10.255.$x.0/29 --version=$MLP_TPU_TF_VERSION --network=default --accelerator-type=v2-8 --zone $MLP_GCP_ZONE 2>&1 | tee /tmp/create_tpu_log.txt


if grep -q "Try a different range." /tmp/create_tpu_log.txt; then
  # In this case, the network address is taken adn we should re-try this action, incrementing x
  echo "Trying a different range.";
else
  break
fi


done
