FROM tensorflow/tensorflow:nightly-gpu-py3


WORKDIR /root
ENV HOME /root

RUN echo "1" >> VERSION_INFO

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y build-essential git
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update
RUN apt-get install -y python3.6
RUN apt-get install -y python3-pip


RUN pip3 install --upgrade pip
RUN pip3 install pyyaml

ADD . /root

RUN git clone https://github.com/tensorflow/benchmarks.git benchmarks
RUN /root/scripts/setup_tfcnn_benchmarks.sh

ENTRYPOINT ["/bin/bash"]

