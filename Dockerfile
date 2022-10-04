FROM ubuntu:20.04
MAINTAINER Matt Godbolt <matt@godbolt.org>

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
    libelf-dev \
    linux-libc-dev \
    autoconf \
    automake \
    make \
    ninja-build \
    patch \
    subversion \
    texinfo \
    unzip \
    wget \
    xz-utils \
    libcurl4-openssl-dev

RUN cd /tmp && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws*

RUN apt install -y python3.9 python3-pip python3.9-venv
RUN python3 -m pip install conan

RUN mkdir -p /tmp/build
COPY build /tmp/build

RUN conan remote clean && \
    conan remote add ceserver https://conan.compiler-explorer.com/ True

WORKDIR /tmp/build
