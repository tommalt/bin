#!/bin/bash

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	echo "Usage: `basename $0` <sys>"
	echo "Install files to \$HOME/bin"
	echo "If sys is specified, install sys files"
	exit 1;
fi

if [ "$1" = "sys" ]; then
	sudo cp sys/mongodb.service-ulimit.hook /usr/share/libalpm/hooks/mongodb.service-ulimit.hook
	exit 0
fi
## else

# user files
BINDIR=/home/tom/bin
ignore=`cat ignore`
cmd="ls"
for i in $ignore; do
	cmd="$cmd -I $i"
done
files=`eval "$cmd"`
for f in $files; do
	install -m755 "$f" "$BINDIR"
done
exit 0
