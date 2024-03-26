# syntax=docker/dockerfile:1

FROM dustynv/jetson-inference:r32.7.1

# set version label
ARG BUILD_DATE
ARG VERSION
ARG WHISPER_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"

ENV HOME=/config

COPY . .

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential \
    software-properties-common && \
  add-apt-repository ppa:deadsnakes/ppa && \
  apt install python3.10 && \
  RUN rm /usr/bin/python3 && ln -s /usr/bin/python3.10 /usr/bin/python3 && \
  python3 -m venv /lsiopy && \
  pip3 install -U --no-cache-dir \
    pip \
    wheel && \
  pip3 install -U --no-cache-dir \
    -e . && \
  apt-get purge -y --auto-remove \
    build-essential \
  rm -rf \
    /var/lib/apt/lists/* \
    /tmp/*

COPY root/ /
COPY models /
COPY whisper /usr/local/bin/

VOLUME /config

EXPOSE 10300
