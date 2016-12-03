#----------------------------------------------------------------#
# Dockerfile to build a container for binary reverse engineering #
# and exploitation.  Cut down version of superkojiman/pwnbox.    #
#----------------------------------------------------------------#

FROM phusion/baseimage
MAINTAINER rasta@rastamouse.me

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y upgrade

#-------------------------------------#
# Install packages from Ubuntu repos  #
#-------------------------------------#
RUN apt-get install -y \
	zsh \
    gdb \
    python-dev \
    python-pip \
    nasm \
    vim \
    tmux \
    git \
    socat \
    netcat \
    nmap \
    wget \
    man-db \
    manpages-dev \
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
    ropgadget

# install pwntools 3
RUN pip install --upgrade pwntools

#-------------------------------------#
# Install stuff from GitHub repos     #
#-------------------------------------#

RUN git clone https://github.com/robbyrussell/oh-my-zsh.git
RUN git clone https://github.com/tmux-plugins/tmux-resurrect.git /opt/tmux-resurrect
RUN git clone https://github.com/longld/peda.git /opt/peda

ENTRYPOINT ["/usr/bin/zsh"]