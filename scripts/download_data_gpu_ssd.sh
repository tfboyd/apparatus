set -e
gsutil cp -r gs://imagenet-copy/imagenet $1

ls -lah $1

mv $1/*/* $1/
