FROM ubuntu:latest

# CC65 and other dependencies to build other projects
RUN apt-get update  && export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install  --no-install-recommends \
  less vim srecord xa65 gawk avr-libc \
  gcc g++ git gpg make \
  autoconf automake autotools-dev m4 \
  asciidoc xmlto curl \
  ca-certificates \
  libc-dev libusb-dev libusb-1.0-0-dev \
  libgmp3-dev libssl-dev \
  bison flex libxml2-dev subversion libboost-all-dev texinfo \
	cpanminus cpanminus \
  pkg-config libsdl2-dev &&\
  echo 'deb http://download.opensuse.org/repositories/home:/strik/Debian_11/ /' | tee /etc/apt/sources.list.d/home:strik.list && \
  curl -fsSL https://download.opensuse.org/repositories/home:strik/Debian_11/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_strik.gpg > /dev/null && \
  apt-get -y install cc65 && \
  # turn the detached head message off
  git config --global advice.detachedHead false

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

# agon-ez80asm for eZ80 assembly
# https://github.com/envenomator/agon-ez80asm
 RUN cd /build && \
   git clone --depth 1 --branch v0.96 https://github.com/envenomator/agon-ez80asm.git && \
   cd /build/agon-ez80asm && \
   sed -i 's/#define AGON//g' src/config.h && \
   mkdir obj && \
   make release && \
   cp bin/project /usr/local/bin/asm

# z88dk https://github.com/z88dk/z88dk/blob/master/z88dk.Dockerfile
ENV Z88DK_PATH="/opt/z88dk"

RUN git clone --depth 1 --recursive https://github.com/z88dk/z88dk.git ${Z88DK_PATH} && \
  cpanm -l $HOME/perl5 --no-wget local::lib Template::Plugin::YAML && \
  cd ${Z88DK_PATH} \
  && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)" \
  && chmod 777 build.sh \
  && BUILD_SDCC=1 BUILD_SDCC_HTTP=1 ./build.sh

ENV PATH="${Z88DK_PATH}/bin:${PATH}" \
    ZCCCFG="${Z88DK_PATH}/lib/config/"

# Minipro
RUN cd /build && \
  git clone --depth 1 --branch 0.5 https://gitlab.com/DavidGriffith/minipro.git && \
  cd /build/minipro && \
  export PREFIX=/opt/minipro && \
  make all && \
  make install

# Emulator Kit
# https://github.com/EtchedPixels/EmulatorKit
RUN cd /build && \
  git clone --depth 1 https://github.com/EtchedPixels/EmulatorKit.git && \
  cd /build/EmulatorKit && \
  make && \
  mkdir -p /opt/EmulatorKit && \
  cp -r /build/EmulatorKit/* /opt/EmulatorKit

# z80emu
RUN cd /build && \
  mkdir -p /opt/z80emu/bin && \
  apt install unzip && \
  curl -L https://github.com/rprouse/Z80Emu/releases/latest/download/Z80Emu-Linux.zip --output Z80Emu-Linux.zip && \
  unzip Z80Emu-Linux.zip && \
  cp -r Z80Emu/bin/Release/net7.0/linux-x64/publish/* /opt/z80emu/bin/ && \
  ln -s /opt/z80emu/bin/Z80Emu /opt/z80emu/bin/z80emu

# Cleanup
RUN cd / && \
  rm -rf /build && \
  apt-get -y autoremove --purge && \
  rm -rf /var/lib/apt/lists/*

ENV PATH /opt/cc65/bin:/opt/minipro/bin:/opt/z80emu/bin:$PATH

LABEL author="Rob Prouse <rob@prouse.org>"
LABEL mantainer="Rob Prouse <rob@prouse.org>"

ARG VERSION="2.0.0"
ENV VERSION=$VERSION

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0" \
	  org.label-schema.build-date=$BUILD_DATE \
	  org.label-schema.name="rprouse/asm-dev" \
	  org.label-schema.description="build cc65 compiler, sjasmplus, nasm, rasm, spasm-ng, agon asm, z88dk, emulator kit, z80emu and minipro" \
	  org.label-schema.version=$VERSION \
	  org.label-schema.vendor="rprouse" \
	  org.label-schema.url="https://alteridem.net/" \
	  org.label-schema.vcs-url="https://github.com/rprouse/asm-dev-docker" \
	  org.label-schema.vcs-ref=$VCS_REF \
	  org.label-schema.docker.cmd="docker build -t rprouse/asm-dev -f Dockerfile ."