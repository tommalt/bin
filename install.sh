#!/bin/bash

# system files
cp mongodb.service-ulimit.hook /usr/share/libalpm/hooks/mongodb.service-ulimit.hook

# user files
BINDIR=/home/tom/bin
USRFILES="
mongodb.service-ulimit.py
arch-mirrors.sh
monitor
"

for f in $USRFILES; do
	cp $f "$BINDIR/$f"
done

chown -R tom:tom "$BINDIR"
