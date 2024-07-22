#!/bin/bash

TMP_FOLDER=/tmp/dots
mkdir -p "$TMP_FOLDER"
wget --output-document "$TMP_FOLDER/task_linux_386.deb" https://github.com/go-task/task/releases/latest/download/task_linux_386.deb
sudo dpkg -i "$TMP_FOLDER/task_linux_386.deb"

# install all debian packages needed for my dotfiles
sudo apt -y install \
  autoconf \
  autojump \
  automake \
  bat \
  bison \
  build-essential \
  clangd-13 \
  curl \
  fop \
  git \
  global \
  httpie \
  inotify-tools \
  libbz2-dev \
  libclang-13-dev \
  libffi-dev \
  libgl1-mesa-dev \
  libglu1-mesa-dev \
  libmnl-dev \
  liblzma-dev \
  libncurses-dev \
  libncurses5-dev \
  libncursesw5-dev \
  libpng-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssh-dev \
  libssl-dev \
  libterm-readkey-perl \
  libwxgtk3.0-gtk3-dev \
  libxml2-dev \
  libxml2-utils \
  libxmlsec1-dev \
  m4 \
  openjdk-11-jdk \
  pkg-config \
  postgresql \
  postgresql-client \
  pspg \
  python3-tk \
  ruby \
  squashfs-tools \
  ssh-askpass \
  tk-dev \
  tmux \
  tree \
  universal-ctags \
  unixodbc-dev \
  wx-common \
  xsltproc \
  xz-utils \
  zlib1g-dev \
  zsh
