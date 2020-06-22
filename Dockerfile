FROM ubuntu:18.04
LABEL maintainer="Danil Borchevkin <danil@borchevkin>"
LABEL Description="Image for building ARM GCC projects inclding Git, Python, CMake"
WORKDIR /work

ADD . /work

# Install any needed packages specified in requirements.txt
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
# Development files
    build-essential \
    git \
    unzip \
    python3-pip \
    bzip2 \
    wget && \
    apt-get clean

RUN rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN wget -c -q "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

# Install CMake
RUN wget -c -q https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4-Linux-x86_64.sh -O /tmp/cmake.sh \
    && chmod u+x /tmp/cmake.sh \
    && /tmp/cmake.sh --skip-license --prefix=/usr/local/ \
    && rm /tmp/cmake.sh

# Install python dependencies for AWS
RUN pip3 install awscli boto3==1.12.11

# Download ARM GCC 9 compiler
RUN wget -qO- https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 | tar -xj

# Set ENV
ENV PATH "/work/gcc-arm-none-eabi-9-2019-q4-major/bin:$PATH"

# Set ENV var for toolchain
ENV ARM_TOOLCHAIN_PATH "/work/gcc-arm-none-eabi-9-2019-q4-major"
