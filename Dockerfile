FROM ubuntu:22.04
LABEL org.opencontainers.image.authors="Matt Godbolt <matt@godbolt.org>"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y -q && apt upgrade -y -q && apt upgrade -y -q && apt install -y -q \
    bison \
    bzip2 \
    curl \
    file \
    flex \
    gawk \
    git \
    libc6-dev-i386 \
    libc6-dev-arm64-cross \
    libelf-dev \
    linux-libc-dev \
    autoconf \
    automake \
    make \
    binutils-multiarch \
    elfutils \
    ninja-build \
    patch \
    subversion \
    texinfo \
    unzip \
    wget \
    xz-utils \
    libcurl4-openssl-dev

RUN apt-get install -y -q libfreetype6-dev libfontconfig1-dev libglib2.0-dev libgstreamer1.0-dev \
                libgstreamer-plugins-base1.0-dev libice-dev libaudio-dev libgl1-mesa-dev libc6-dev \
                libsm-dev libxcursor-dev libxext-dev libxfixes-dev libxi-dev libxinerama-dev \
                libxrandr-dev libxrender-dev libxkbcommon-dev libxkbcommon-x11-dev libx11-dev

RUN apt-get install -y -q libxcb1-dev libx11-xcb-dev libxcb-glx0-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-keysyms1-dev \
                libxcb-render0-dev libxcb-render-util0-dev libxcb-randr0-dev libxcb-shape0-dev \
                libxcb-shm0-dev libxcb-sync-dev libxcb-xfixes0-dev libxcb-xinerama0-dev libxcb-xkb-dev

RUN cd /tmp && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws*

# install pyenv instead of using OS supplied python
RUN apt-get install -y -q build-essential libssl-dev zlib1g-dev \
                libbz2-dev libreadline-dev libsqlite3-dev curl git \
                libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

RUN curl https://pyenv.run | bash

ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"

RUN pyenv install 3.10.16 && \
    pyenv global 3.10.16

RUN mkdir -p /tmp/build
COPY build /tmp/build

WORKDIR /tmp/build

# using `eval "$(pyenv init -)"` doesn't really work in docker, so we just set the path manually
ENV PATH="/root/.pyenv/shims:/root/.pyenv/versions/3.10.16/bin:$PATH"

RUN python -m pip install conan==1.59

RUN conan remote clean && \
    conan remote add ceserver https://conan.compiler-explorer.com/ True
