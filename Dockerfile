FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

RUN apt-get update
RUN apt-get install -y build-essential git python python-pip python3-pip python3

RUN apt-get install -y curl
RUN pip3 install --upgrade pip
RUN pip3 install pyyaml

WORKDIR /root
ENV HOME /root
ADD . /root

RUN echo "test" > note

ENTRYPOINT ["/bin/bash"]

