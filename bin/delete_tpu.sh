
HOST=`hostname`
ZONE=`gcloud compute instances list $HOST --format 'csv[no-heading](zone)' 2>/dev/null`

TPU_NAME=$1
echo "TPU_NAME: $TPU_NAME"
yes | gcloud beta compute tpus delete $TPU_NAME --zone $ZONE
