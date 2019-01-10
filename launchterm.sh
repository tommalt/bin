#!/bin/sh

term="$1"

if [ -z "$term" ]; then
	term=urxvt
fi

term=$(basename $term)
if [ "$term" = urxvt ]; then
	if pgrep urxvtd; then
		term=urxvtc
	fi
fi

if [ ! -z "$2" ]; then
	termd.sh "$term" "$2" &
else
	$term &
fi
