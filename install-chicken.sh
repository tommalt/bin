#!/bin/bash

echo "installing chicken archlinux package"
sudo pacman --noconfirm -S chicken

echo "installing the GNU readline egg"
chicken-install -s readline

echo "adding readline statements to ~/.csirc"
cat >> ~/.csirc <<EOF
(use readline)
(current-input-port (make-readline-port))
(install-history-file #f "/.csi.history")
(parse-and-bind "set editing-mode vi")
EOF


