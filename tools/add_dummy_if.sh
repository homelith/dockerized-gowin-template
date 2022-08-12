#!/bin/bash

IFNAME=licdongle0
HWADDR=${1}
if [ -z "${HWADDR}" ]; then
  echo "usage ./add_dummy_if.sh {MAC address to be set to dummy NIC I/F (e.g. 06:12:34:56:78:9a)}"
  exit
fi

sudo ip link add ${IFNAME} type dummy
sudo ip link set dev ${IFNAME} address ${HWADDR}

