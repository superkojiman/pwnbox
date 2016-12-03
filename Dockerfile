#----------------------------------------------------------------#
# Dockerfile to build a container for binary reverse engineering #
# and exploitation. Suitable for CTFs.                           #
#                                                                #
# To build: docker build -t superkojiman/pwnbox                  #
#----------------------------------------------------------------#

FROM phusion/baseimage:0.9.19
MAINTAINER superkojiman@techorganic.com

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y upgrade

#-------------------------------------#
# Install packages from Ubuntu repos  #
#-------------------------------------#
RUN apt-get install -y \
    build-essential \
    gcc-multilib \
    g++-multilib \
    gdb \
    gdb-multiarch \
    python-dev \
    python3-dev \
    python-pip \
    python3-pip \
    default-jdk \
    net-tools \
    nasm \
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
    exiftool \
    virtualenvwrapper \
    man-db \
    manpages-dev \
    libini-config-dev \
    libssl-dev \
    libffi-dev \
    libglib2.0-dev \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libc6-dev-i386

RUN apt-get -y autoremove
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#-------------------------------------#
# Install stuff from pip repos        #
#-------------------------------------#
RUN pip install \
    pycipher \
    uncompyle \
    ropgadget \
    distorm3 \
    filebytes \
    capstone \
    python-constraint

# setup angr virtualenv
RUN bash -c 'source /etc/bash_completion.d/virtualenvwrapper && \
    mkvirtualenv angr && \
    pip install angr && \
    deactivate'

# install pwntools 3
RUN pip install --upgrade pwntools

#-------------------------------------#
# Install stuff from GitHub repos     #
#-------------------------------------#
RUN git clone https://gist.github.com/47e3a5ac99867e7f4e0d.git /opt/binstall && \
    cd /opt/binstall && \
    chmod 755 binstall.sh && \
    ./binstall.sh amd64 && \
    ./binstall.sh i386

RUN git clone https://github.com/radare/radare2.git /opt/radare2 && \
    cd /opt/radare2 && \
    git fetch --tags && \
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && \
    ./sys/install.sh  && \
    make symstall

RUN git clone https://github.com/sashs/Ropper.git /opt/ropper && \
    cd /opt/ropper && \
    python setup.py install
RUN rm -rf /opt/ropper

RUN git clone https://github.com/packz/ropeme.git /opt/ropeme && \
    sed -i 's/distorm/distorm3/g' /opt/ropeme/ropeme/gadgets.py

# install rp++
RUN mkdir /opt/rp
RUN wget https://github.com/downloads/0vercl0k/rp/rp-lin-x64 -P /opt/rp
RUN wget https://github.com/downloads/0vercl0k/rp/rp-lin-x86 -P /opt/rp

RUN git clone https://github.com/hellman/libformatstr.git /opt/libformatstr && \
    cd /opt/libformatstr && \
    python setup.py install
RUN rm -rf /opt/libformatstr

RUN git clone https://github.com/zardus/preeny.git /opt/preeny && \
    cd /opt/preeny && \
    make

RUN git clone https://github.com/tmux-plugins/tmux-resurrect.git /opt/tmux-resurrect
RUN git clone https://github.com/niklasb/libc-database /opt/libc-database

RUN git clone https://github.com/longld/peda.git /opt/peda
RUN git clone https://github.com/hugsy/gef.git /opt/gef

ENTRYPOINT ["/bin/bash"]
