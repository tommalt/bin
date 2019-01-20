#!/bin/bash

if [ $EUID -ne 0 ]; then
	echo 'This script must be run as root'
	exit 1
fi

set -e
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.bak

rankmirrors -n 6 /etc/pacman.d/mirrorlist.bak >/etc/pacman.d/mirrorlist
