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
      cmake \
      python3-pip \
      bzip2 \
      wget && \
    apt-get clean

# Download ARM GCC 9 compiler
RUN wget -qO- https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2 | tar -xj

# Set ENV
ENV PATH "/work/gcc-arm-none-eabi-9-2019-q4-major/bin:$PATH"
