#!/usr/bin/env bash

# Store your .gdbinit, .radare2rc, .vimrc, etc in a ./rc directory. The contents will be copied to
# /root/ in the container.

ESC="\x1B["
RESET=$ESC"39m"
RED=$ESC"31m"
GREEN=$ESC"32m"
BLUE=$ESC"34m"

if [[ -z ${1} ]]; then
    echo -e "${RED}Missing argument container name.${RESET}"
    exit 0
fi

cont_name=${1}

# Create docker container and run in the background
docker run -it \
    -d \
    -h ${cont_name} \
    --security-opt seccomp:unconfined \
    --name ${cont_name}

# Tar config files in rc and extract it into the container
if [[ -d rc ]]; then
    cd rc
    if [[ -f rc.tar ]]; then
        rm -f rc.tar
    fi
    for i in .* *; do
        if [[ ! ${i} == "." && ! ${i} == ".." ]]; then
            tar rf rc.tar ${i}
        fi
    done
    cd - > /dev/null 2>&1
    cat rc/rc.tar | docker cp - ${cont_name}:/root/
else
    echo -e "${RED}No rc directory found. Nothing to copy to container.${RESET}"
fi

# Create stop/rm script for container
cat << EOF > ${cont_name}-stop.sh
#!/bin/bash
docker stop ${cont_name}
docker rm ${cont_name}
rm -f ${cont_name}-stop.sh
EOF
chmod 755 ${cont_name}-stop.sh

# Create a workdir for this CTF
docker exec ${cont_name} mkdir /root/work

# Get a shell
docker attach ${cont_name}