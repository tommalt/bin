#!/usr/bin/wish

# window size
set width 400
set height 300
wm geometry . "${width}x$height"

set value 6500

proc scale_handler { value } {
	exec redshift -P -O "$value"
}

proc reset { } {
	global value
	set value 6500
	scale_handler $value
}

scale .temperature -from 1000 -to 25000 -resolution 100 \
	-sliderlength 90 -width 25 -variable value \
	-label temperature -orient horizontal -command scale_handler
pack .temperature -fill both -expand true

button .reset -text "Reset" -command reset
pack .reset -fill x

button .quit -text "Quit" -command exit
pack .quit -fill x
