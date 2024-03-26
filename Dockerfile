# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy

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
    python3-dev \
    python3-venv && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
    pip \
    wheel && \
  pip install -U --no-cache-dir \
    -e . && \
  apt-get purge -y --auto-remove \
    build-essential \
    python3-dev && \
  rm -rf \
    /var/lib/apt/lists/* \
    /tmp/*

COPY root/ /
COPY models /
COPY whisper /usr/local/bin/

VOLUME /config

EXPOSE 10300
