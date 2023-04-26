FROM ubuntu:latest

RUN apt-get update  && export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install  --no-install-recommends \
  less vim srecord xa65 gawk avr-libc \
  gcc g++ git gpg make \
  autoconf automake autotools-dev m4 \
  asciidoc xmlto curl \
  ca-certificates \
  libc-dev libusb-dev libusb-1.0-0-dev \
  libgmp3-dev libssl-dev \
  pkg-config &&\
  # turn the detached head message off
  git config --global advice.detachedHead false

# CC65
RUN echo 'deb http://download.opensuse.org/repositories/home:/strik/Debian_11/ /' | tee /etc/apt/sources.list.d/home:strik.list && \
  curl -fsSL https://download.opensuse.org/repositories/home:strik/Debian_11/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_strik.gpg > /dev/null && \
  apt-get update && \
  apt-get -y install cc65

# SJAsmPlus
RUN mkdir /build && \
  cd /build && \
  git clone --recursive --depth 1 --branch v1.20.1 https://github.com/z00m128/sjasmplus.git && \
  cd /build/sjasmplus && \
  make all && \
  make install

# NASM
RUN cd /build && \
  git clone --depth 1 --branch nasm-2.16.01 https://github.com/netwide-assembler/nasm.git && \
  cd /build/nasm && \
  sh autogen.sh && \
  sh configure && \
  make && \
  make manpages && \
  make install

# RASM
RUN cd /build && \
  git clone --depth 1 --branch v1.8 https://github.com/EdouardBERGE/rasm.git && \
  cd /build/rasm && \
  make && \
  cp ./rasm.exe /usr/local/bin/rasm

# spasm-ng for eZ80 assembly
# https://github.com/alberthdev/spasm-ng/
# https://github.com/tomm/spasm-ng
RUN cd /build && \
  git clone --depth 1 https://github.com/tomm/spasm-ng.git && \
  cd /build/spasm-ng && \
  make && \
  make install

# Minipro
RUN cd /build && \
  git clone --depth 1 --branch 0.5 https://gitlab.com/DavidGriffith/minipro.git && \
  cd /build/minipro && \
  export PREFIX=/opt/minipro && \
  make all && \
  make install

# Cleanup
RUN cd / && \
  rm -rf /build && \
  apt-get -y autoremove --purge && \
  rm -rf /var/lib/apt/lists/*

ENV PATH /opt/cc65/bin:/opt/minipro/bin:$PATH

LABEL author="Rob Prouse <rob@prouse.org>"
LABEL mantainer="Rob Prouse <rob@prouse.org>"

ARG VERSION="1.6.0"
ENV VERSION=$VERSION

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0" \
	  org.label-schema.build-date=$BUILD_DATE \
	  org.label-schema.name="rprouse/asm-dev" \
	  org.label-schema.description="build cc65 compiler, sjasmplus, nasm and minipro" \
	  org.label-schema.version=$VERSION \
	  org.label-schema.vendor="rprouse" \
	  org.label-schema.url="https://alteridem.net/" \
	  org.label-schema.vcs-url="https://github.com/rprouse/asm-dev-docker" \
	  org.label-schema.vcs-ref=$VCS_REF \
	  org.label-schema.docker.cmd="docker build -t rprouse/asm-dev -f Dockerfile ."