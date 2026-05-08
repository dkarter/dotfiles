FROM ghcr.io/dkarter/dotfiles:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    less \
    openssh-client \
    sudo \
    zsh \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
