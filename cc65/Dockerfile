FROM ubuntu:latest

RUN apt-get update  && export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install cc65 && \
  apt-get -y autoremove --purge && \
  rm -rf /var/lib/apt/lists/*

ENV PATH /opt/cc65/bin:$PATH

WORKDIR /workspace