FROM ubuntu

SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ="America/Salt Lake City"

RUN apt-get -y update && apt-get -y install \
   wget \
   unzip \
   cmake \
   make \
   g++ \
   build-essential \
   python3 \
   cmake \
   git \
   pkg-config \
   libgtk-3-dev \
   libavcodec-dev \
   libavformat-dev \
   libswscale-dev \
   libv4l-dev \
   libxvidcore-dev \
   libx264-dev libjpeg-dev \
   libpng-dev libtiff-dev \
   gfortran \
   openexr \
   libatlas-base-dev \
   python3-dev \
   python3-numpy \
   libtbb2 \
   libtbb-dev \
   libdc1394-22-dev 
    
# Download opencv, unzip, and build it.
# IMPORTANT: on line 50, set the number after j to be the number of cores on your system
RUN mkdir ~/opencv_build && cd ~/opencv_build \
    && git clone https://github.com/opencv/opencv.git \
    && git clone https://github.com/opencv/opencv_contrib.git \
    && cd ~/opencv_build/opencv \
    && mkdir build && cd build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON .. \
    && make -j12 \
    && make install

RUN apt-get -y install pip \
   && pip install imutils \
   && pip install -U matplotlib
 
