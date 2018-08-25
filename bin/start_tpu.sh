
HOST=`hostname`
ZONE=`gcloud compute instances list $HOST --format 'csv[no-heading](zone)' 2>/dev/null`
TF_VERSION=1.9

TPU_NAME="$HOST_tpu"


echo $HOST $ZONE


gcloud alpha compute tpus create $TPU_NAME --range=10.123.45.0/29 --version=$TF_VERSION --network=default --accelerator-type=v2-8 --zone $ZONE
