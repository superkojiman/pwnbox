#----------------------------------------------------------------#
# Dockerfile to build a container for binary reverse engineering #
# and exploitation. Suitable for CTFs.                           #
#                                                                #
# See https://github.com/superkojiman/pwnbox for details.        #
#                                                                #
# To build: docker build -t superkojiman/pwnbox                  #
#----------------------------------------------------------------#

FROM phusion/baseimage
LABEL maintainer="superkojiman@techorganic.com"

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y upgrade

#-------------------------------------#
# Install packages from Ubuntu repos  #
#-------------------------------------#
RUN apt-get install -y \
    sudo \
    build-essential \
    gcc-multilib \
    g++-multilib \
    gdb \
    gdb-multiarch \
    python-dev \
    python3-dev \
    python-pip \
    python3-pip \
    ipython \
    default-jdk \
    net-tools \
    nasm \
    cmake \
    rubygems \
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
    virtualenvwrapper \
    upx-ucl \
    man-db \
    manpages-dev \
    libtool-bin \
    bison \
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
    r2pipe \
    scapy \
    python-constraint

# setup angr virtualenv
RUN bash -c 'source /etc/bash_completion.d/virtualenvwrapper && \
    mkvirtualenv angr && \
    pip install angr && \
    deactivate'

# install pwntools 3
RUN pip install --upgrade pwntools

# install docopt for xortool
RUN pip install docopt

#-------------------------------------#
# Install stuff from GitHub repos     #
#-------------------------------------#
# install capstone
RUN git clone https://github.com/aquynh/capstone.git /opt/capstone && \
    cd /opt/capstone && \
    ./make.sh && \
    ./make.sh install  && \
    cd bindings/python && \
    make install && \
    make install3 

RUN git clone https://gist.github.com/47e3a5ac99867e7f4e0d.git /opt/binstall && \
    cd /opt/binstall && \
    chmod 755 binstall.sh && \
    ./binstall.sh amd64 && \
    ./binstall.sh i386

# install radrare2
RUN git clone https://github.com/radare/radare2.git /opt/radare2 && \
    cd /opt/radare2 && \
    git fetch --tags && \
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && \
    ./sys/install.sh  && \
    make symstall

# install ropper
RUN git clone https://github.com/sashs/Ropper.git /opt/ropper && \
    cd /opt/ropper && \
    python setup.py install
RUN rm -rf /opt/ropper

# install ropeme
RUN git clone https://github.com/packz/ropeme.git /opt/ropeme && \
    sed -i 's/distorm/distorm3/g' /opt/ropeme/ropeme/gadgets.py

# install rp++
RUN mkdir /opt/rp
RUN wget https://github.com/downloads/0vercl0k/rp/rp-lin-x64 -P /opt/rp
RUN wget https://github.com/downloads/0vercl0k/rp/rp-lin-x86 -P /opt/rp

# install retargetable decompiler scripts
RUN git clone https://github.com/s3rvac/retdec-sh.git /opt/retdec-sh

# install villoc
RUN git clone https://github.com/wapiflapi/villoc.git /opt/villoc 

# install libformatstr
RUN git clone https://github.com/hellman/libformatstr.git /opt/libformatstr && \
    cd /opt/libformatstr && \
    python setup.py install
RUN rm -rf /opt/libformatstr

# install preeny
RUN git clone https://github.com/zardus/preeny.git /opt/preeny && \
    cd /opt/preeny && \
    make

# install xortool
RUN git clone https://github.com/hellman/xortool.git /opt/xortool && \
    cd /opt/xortool && \
    python setup.py install

# install tmux-resurrect
RUN git clone https://github.com/tmux-plugins/tmux-resurrect.git /opt/tmux-resurrect

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

ENTRYPOINT ["/bin/bash"]
