#!/bin/bash

set -e

TF_BENCHMARKS_REPO="https://github.com/tensorflow/benchmarks.git"
TF_BENCHMARKS_DIR="benchmarks"
TF_MODELS_REPO="https://github.com/tensorflow/models.git"
TF_MODELS_DIR="models"
COCO_API_REPO="https://github.com/cocodataset/cocoapi.git"
COCO_API_DIR="cocoapi"

git clone ${TF_BENCHMARKS_REPO}
git clone ${TF_MODELS_REPO}
git clone ${COCO_API_REPO}

