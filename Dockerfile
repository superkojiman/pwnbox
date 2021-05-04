#----------------------------------------------------------------#
# Dockerfile to build a container for binary reverse engineering #
# and exploitation. Suitable for CTFs.                           #
#                                                                #
# See https://github.com/superkojiman/pwnbox for details.        #
#                                                                #
# To build: docker build -t superkojiman/pwnbox                  #
#----------------------------------------------------------------#

FROM ubuntu:18.04
MAINTAINER superkojiman@techorganic.com

ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN yes | unminimize
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y upgrade

#-------------------------------------#
# Install packages from Ubuntu repos  #
#-------------------------------------#
RUN apt-get install -y \
    sudo \
    apt-utils \
    locales \
    build-essential \
    gcc-multilib \
    g++-multilib \
    gdb \
    gdb-multiarch \
    python3-dev \
    python3-pip \
    ipython3 \
    man-db \
    manpages-posix \
    default-jdk \
    net-tools \
    nasm \
    cmake \
    rubygems \
    ruby-dev \
    vim \
    tmux \
    git \
    binwalk \
    strace \
    ltrace \
    autoconf \
    socat \
    netcat \
    nmap \
    wget \
    tcpdump \
    exiftool \
    squashfs-tools \
    unzip \
    upx-ucl \
    man-db \
    manpages-dev \
    libtool-bin \
    bison \
    gperf \
    libseccomp-dev \
    libini-config-dev \
    libssl-dev \
    libffi-dev \
    libc6-dbg \
    libglib2.0-dev \
    libc6:i386 \
    libc6-dbg:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libc6-dev-i386

RUN apt-get -y autoremove
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# update locale to include en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN update-locale

#-------------------------------------#
# Install stuff from pip repos        #
#-------------------------------------#
RUN pip3 install r2pipe
RUN pip3 install scapy
RUN pip3 install python-constraint
RUN pip3 install pycipher
RUN pip3 install uncompyle6
RUN pip3 install pipenv
RUN pip3 install manticore[native]
RUN pip3 install ropper
RUN pip3 install meson
RUN pip3 install ninja

# install pwntools 3
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade pwntools

# install xortool
RUN python3 -m pip install xortool

#-------------------------------------#
# Install stuff from GitHub repos     #
#-------------------------------------#
# install rizin
RUN git clone https://github.com/rizinorg/rizin /opt/rizin && \
    cd /opt/rizin && \
    meson build && \
    ninja -C build && \
    ninja -C build install

# install libc-database
RUN git clone https://github.com/niklasb/libc-database /opt/libc-database

# install peda
RUN git clone https://github.com/longld/peda.git /opt/peda

# install gef
RUN git clone https://github.com/hugsy/gef.git /opt/gef

# install pwndbg
RUN git clone https://github.com/pwndbg/pwndbg.git /opt/pwndbg && \
    cd /opt/pwndbg && \
    ./setup.sh

# install libseccomp
RUN git clone https://github.com/seccomp/libseccomp.git /opt/libseccomp && \
    cd /opt/libseccomp && \
    ./autogen.sh && ./configure && make && make install 

# install PinCTF
RUN git clone https://github.com/ChrisTheCoolHut/PinCTF.git /opt/PinCTF && \
    cd /opt/PinCTF && \
    ./installPin.sh 

# install one_gadget
RUN gem install one_gadget

# install seccomp-tools
RUN gem install seccomp-tools


ENTRYPOINT ["/bin/bash"]
