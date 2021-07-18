# Using an Ubuntu container because I can't get sjasmplus to build in Alpine
FROM mcr.microsoft.com/vscode/devcontainers/base:focal

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
  # turn the detached message off
  git config --global advice.detachedHead false && \
  # CC65
  mkdir /build && cd /build && \
  git clone --depth 1 --branch V2.19 https://github.com/cc65/cc65.git && \
  cd /build/cc65 && \
  export PREFIX=/opt/cc65 && \
  CFLAGS="-std=c99 -O2" make -j$(nproc) && \
  make install && \
  # SJAsmPlus
  cd /build && \
  git clone --depth 1 --branch v1.18.2 https://github.com/z00m128/sjasmplus && \
  cd /build/sjasmplus && \
  make all && \
  make install && \
  # NASM
  cd /build && \
  git clone --depth 1 --branch nasm-2.15.05 https://github.com/netwide-assembler/nasm.git && \
  cd /build/nasm && \
  sh autogen.sh && \
  sh configure && \
  make && \
  make manpages && \
  make install && \
  # Minipro
  cd /build && \
  git clone --depth 1 --branch 0.5 https://gitlab.com/DavidGriffith/minipro.git && \
  cd /build/minipro && \
  export PREFIX=/opt/minipro && \
  make all && \
  make install && \
  # Cleanup
  cd / && \
  rm -rf /build && \
  apt-get -y autoremove --purge && \
  rm -rf /var/lib/apt/lists/*

ENV PATH /opt/cc65/bin:/opt/minipro/bin:$PATH

LABEL author="Rob Prouse <rob@prouse.org>"
LABEL mantainer="Rob Prouse <rob@prouse.org>"

ARG VERSION="1.1.0"
ENV VERSION=$VERSION

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0" \
	  org.label-schema.build-date=$BUILD_DATE \
	  org.label-schema.name="rprouse/asm-dev" \
	  org.label-schema.description="build cc65 compiler, sjasmplus and minipro" \
	  org.label-schema.version=$VERSION \
	  org.label-schema.vendor="rprouse" \
	  org.label-schema.url="https://alteridem.net/" \
	  org.label-schema.vcs-url="https://github.com/rprouse/asm-dev-docker" \
	  org.label-schema.vcs-ref=$VCS_REF \
	  org.label-schema.docker.cmd="docker build -t rprouse/asm-dev -f Dockerfile ."