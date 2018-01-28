#!/bin/bash

# system files
cp mongodb.service-ulimit.hook /usr/share/libalpm/hooks/mongodb.service-ulimit.hook

BINDIR=/home/tom/bin
USRFILES="
mongodb.service-ulimit.py
arch-mirrors.sh
"

for f in $USRFILES; do
	cp $f "$BINDIR/$f"
done

chown tom:tom "$BINDIR"
