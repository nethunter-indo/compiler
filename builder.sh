#!/bin/bash
# Kernel Builder Script
# Hendra Manudinata & Ripunk 16
# Nyolong dosa anj*ng


# Color

red="\e[31m"
green="\e[32m"
yellow="\e[1;33m"
netral="\e[0m"

# Needed Variable
DIRNAME=$(pwd)

# Trap Ctrl + C and call it

trap ctrl_c INT

function ctrl_c() {
	echo ""
        echo -e $red"[!] Ctrl+C pressed, interrupting..."
	echo ""
	sleep 0.5
	echo -e $green"Bye!"$netral
	sleep 0.5
}

function detect_source_exist() {
	echo ""
	[ -d $DIRNAME/source/* ] || 
}
