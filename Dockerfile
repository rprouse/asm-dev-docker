# Using an Debian container because I can't get sjasmplus to build in Alpine
# nor CC65 to build on Ubuntu
FROM mcr.microsoft.com/vscode/devcontainers/base:bullseye

RUN apt-get update  && export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install  --no-install-recommends \
  less \
  vim \
  srecord \
  xa65 gawk avr-libc \
  gcc \
  g++ \
  git \
  gpg \
  make \
  autoconf automake autotools-dev m4 \
  asciidoc xmlto \
  ca-certificates \
  libc-dev libusb-dev libusb-1.0-0-dev \
  pkg-config &&\
  # turn the detached head message off
  git config --global advice.detachedHead false

# CC65
RUN mkdir /build && cd /build && \
  git clone --depth 1 --branch V2.19 https://github.com/cc65/cc65.git && \
  cd /build/cc65 && \
  export PREFIX=/opt/cc65 && \
  CFLAGS="-std=c99 -O2" make -j$(nproc) && \
  make install

# SJAsmPlus
RUN cd /build && \
  git clone --recursive --depth 1 --branch v1.20.0 https://github.com/z00m128/sjasmplus.git && \
  cd /build/sjasmplus && \
  make all && \
  make install

# NASM
RUN cd /build && \
  git clone --depth 1 --branch nasm-2.15.05 https://github.com/netwide-assembler/nasm.git && \
  cd /build/nasm && \
  sh autogen.sh && \
  sh configure && \
  make && \
  make manpages && \
  make install

# RASM
RUN cd /build && \
  git clone --depth 1 --branch v1.6 https://github.com/EdouardBERGE/rasm.git && \
  cd /build/rasm && \
  make && \
  cp ./rasm.exe /usr/local/bin/rasm

# spasm-ng for eZ80 assembly
# https://github.com/alberthdev/spasm-ng/
RUN wget http://snapshot.debian.org/archive/debian/20190501T215844Z/pool/main/g/glibc/multiarch-support_2.28-10_amd64.deb && \
  sudo dpkg -i multiarch-support*.deb && \
  wget http://snapshot.debian.org/archive/debian/20170705T160707Z/pool/main/o/openssl/libssl1.0.0_1.0.2l-1%7Ebpo8%2B1_amd64.deb && \
  sudo dpkg -i libssl1.0.0*.deb && \
  wget https://github.com/alberthdev/spasm-ng/releases/download/v0.5-beta.3/spasm-ng_0.5.beta3-1_amd64.deb  && \
  sudo dpkg -i spasm-ng_0.5*.deb && \
  rm -f *.deb

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

ARG VERSION="1.4.1"
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