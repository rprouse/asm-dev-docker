FROM ubuntu:latest AS build

RUN apt-get update  && export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install gcc g++ make git autoconf automake autotools-dev docbook-xsl-doc-pdf asciidoc xmlto && \
  # turn the detached head message off
  git config --global advice.detachedHead false

# NASM
RUN mkdir /build && \
  cd /build && \
  git clone --depth 1 --branch nasm-2.16.03 https://github.com/netwide-assembler/nasm.git && \
  cd /build/nasm && \
  sh autogen.sh && \
  sh configure && \
  make && \
  make manpages && \
  make install

FROM ubuntu:latest AS nasm
RUN apt-get update  && export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install make git

COPY --from=build /usr/local/bin/* /usr/local/bin/
COPY --from=build /usr/local/share/man/man1/* /usr/local/share/man/man1/

# Cleanup
RUN cd / && \
  apt-get -y autoremove --purge && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /src

LABEL author="Rob Prouse <rob@prouse.org>"
LABEL mantainer="Rob Prouse <rob@prouse.org>"

ARG VERSION="2.16.03"
ENV VERSION=$VERSION

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0" \
	  org.label-schema.build-date=$BUILD_DATE \
	  org.label-schema.name="rprouse/nasm" \
	  org.label-schema.description="nasm another Z80 assembler" \
	  org.label-schema.version=$VERSION \
	  org.label-schema.vendor="rprouse" \
	  org.label-schema.url="https://8bitlabs.ca/" \
	  org.label-schema.vcs-url="https://github.com/rprouse/asm-dev-docker" \
	  org.label-schema.vcs-ref=$VCS_REF
