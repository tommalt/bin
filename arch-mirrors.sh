#!/bin/bash

set -e
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.bak

rankmirrors -n 6 /etc/pacman.d/mirrorlist.bak >/etc/pacman.d/mirrorlist
