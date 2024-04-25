FROM ubuntu:latest AS build

RUN apt-get update  && export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install gcc g++ make git && \
  # turn the detached head message off
  git config --global advice.detachedHead false

# RASM
RUN mkdir /build && \
  cd /build && \
  git clone --depth 1 --branch v2.2.3 https://github.com/EdouardBERGE/rasm.git && \
  cd /build/rasm && \
  make && \
  cp ./rasm.exe /usr/local/bin/rasm

FROM ubuntu:latest AS rasm
RUN apt-get update  && export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install make git

COPY --from=build /usr/local/bin/rasm /usr/local/bin/rasm

# Cleanup
RUN cd / && \
  apt-get -y autoremove --purge && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /src

LABEL author="Rob Prouse <rob@prouse.org>"
LABEL mantainer="Rob Prouse <rob@prouse.org>"

ARG VERSION="2.2.3"
ENV VERSION=$VERSION

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0" \
	  org.label-schema.build-date=$BUILD_DATE \
	  org.label-schema.name="rprouse/rasm" \
	  org.label-schema.description="RASM another Z80 assembler" \
	  org.label-schema.version=$VERSION \
	  org.label-schema.vendor="rprouse" \
	  org.label-schema.url="https://8bitlabs.ca/" \
	  org.label-schema.vcs-url="https://github.com/rprouse/asm-dev-docker" \
	  org.label-schema.vcs-ref=$VCS_REF
