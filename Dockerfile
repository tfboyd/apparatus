FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04


WORKDIR /root
ENV HOME /root

RUN echo "1" >> VERSION_INFO

RUN apt-get update
RUN apt-get install -y -no-install-recommends \
      curl \
      build-essential \
      git \
      software-properties-common \
      python-software-properties \
      cuda-command-line-tools-10-0 \
      cuda-cublas-dev-10-0 \
      cuda-cudart-dev-10-0 \
      cuda-cufft-dev-10-0 \
      cuda-curand-dev-10-0 \
      cuda-cusolver-dev-10-0 \
      cuda-cusparse-dev-10-0 \
      libcudnn7=7.3.1.20-1+cuda10.0 \
      libcudnn7-dev=7.3.1.20-1+cuda10.0 \
      libnccl2=2.3.5-2+cuda10.0 \
      libnccl-dev=2.3.5-2+cuda10.0 \
      python3 \
      python3-pip
      ca-certificates \
      virtualenv \
      htop \
      wget


RUN pip3 install --upgrade pip
RUN pip3 install pyyaml

# Install TensorFlow
RUN pip3 install https://storage.googleapis.com/tf-performance/tf_binary/tensorflow-1.12.0rc0.1a6dea3.AVX2-cp35-cp35m-linux_x86_64.whl

ADD . /root

RUN git clone https://github.com/tensorflow/models.git garden
RUN /root/scripts/setup_docker_garden_ncf.sh

ENTRYPOINT ["/bin/bash"]

