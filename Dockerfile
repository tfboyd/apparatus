FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04


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

RUN git clone https://github.com/tensorflow/models.git garden
RUN /root/scripts/setup_docker_garden_ncf.sh

ENTRYPOINT ["/bin/bash"]

