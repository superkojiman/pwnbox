#!/usr/bin/env bash

# Create docker container and run in the background
# Add this if you need to modify anything in /proc:  --privileged 
docker run -it -h pwnbox -d -v $HOME/ctf:/root/ctf --security-opt seccomp:unconfined --name pwnbox pwnbox /bin/bash
