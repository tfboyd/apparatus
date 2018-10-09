set -e
gsutil cp -r gs://mlp_resources/benchmark_data/ssd_gpu $1

ls -lah $1

mv $1/*/* $1/
