#!/usr/bin/env bash

# Run superkojiman/pwnbox container in docker.
# 
# Store your .gdbinit, .radare2rc, .vimrc, etc in a ./rc directory and 
# the contents will be copied to /root/ in the container.

ESC="\x1B["
RESET=$ESC"39m"
RED=$ESC"31m"
GREEN=$ESC"32m"
BLUE=$ESC"34m"

if [[ -z ${1} ]]; then
    echo -e "${RED}Missing argument CTF name.${RESET}"
    exit 0
fi

ctf_name=${1}

# Create a volume for this container 
docker create -v /root/work --name ${ctf_name}_data superkojiman/pwnbox

# Get the volume name for the delete script
vol_name=`docker inspect ${ctf_name}_data | jq '.[].Mounts[].Name' | sed 's/\"//g'`

# Create docker container and run in the background
# Add this if you need to modify anything in /proc:  --privileged 
docker run -it \
    -h ${ctf_name} \
    -d \
    --security-opt seccomp:unconfined \
    --name ${ctf_name} \
    --volumes-from ${ctf_name}_data \
    superkojiman/pwnbox

# Tar config files in rc and extract it into the container
if [[ -d rc ]]; then
    cd rc
    if [[ -f rc.tar ]]; then
        rm -f rc.tar
    fi
    for i in .*; do
        if [[ ! ${i} == "." && ! ${i} == ".." ]]; then
            tar rf rc.tar ${i}
        fi
    done
    cd - > /dev/null 2>&1
    cat rc/rc.tar | docker cp - ${ctf_name}:/root/
    rm -f rc/rc.tar
else
    echo -e "${RED}No rc directory found. Nothing to copy to container.${RESET}"
fi

# Create stop/rm script for container
cat << EOF > ${ctf_name}-stop.sh
#!/bin/bash
echo "Removing ${ctf_name} containers and volumes"
docker stop ${ctf_name}
docker rm ${ctf_name}
docker rm ${ctf_name}_data
docker volume rm ${vol_name}
rm -f ${ctf_name}-stop.sh
EOF
chmod 755 ${ctf_name}-stop.sh

# Create a workdir for this CTF
#docker exec ${ctf_name} mkdir /root/work

# Get a shell
echo -e "${GREEN}                         ______               ${RESET}"
echo -e "${GREEN}___________      ___________  /___________  __${RESET}"
echo -e "${GREEN}___  __ \\_ | /| / /_  __ \\_  __ \\  __ \\_  |/_/${RESET}"
echo -e "${GREEN}__  /_/ /_ |/ |/ /_  / / /  /_/ / /_/ /_>  <  ${RESET}"
echo -e "${GREEN}_  .___/____/|__/ /_/ /_//_.___/\\____//_/|_|  ${RESET}"
echo -e "${GREEN}/_/                           by superkojiman  ${RESET}"
echo ""
docker attach ${ctf_name}
