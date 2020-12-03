#!/bin/bash
# Kernel Builder Script
# Hendra Manudinata & Ripunk 16
# Nyolong dosa woy


# Color

red="\e[31m"
green="\e[32m"
yellow="\e[1;33m"
blue="\e[34m"
netral="\e[0m"

# Needed Variable
DIRNAME=$(pwd)

# Trap Ctrl + C and call it
# And insert it in ctrl_c function
trap ctrl_c INT
function ctrl_c() {
	echo ""
        echo -e $red"[!] Ctrl+C pressed, interrupting..."$netral
	echo ""
	sleep 0.5
	exit 1
}

# Detect if source exist
function detect_source_exist() {
	echo ""
	if [ -d $DIRNAME/source/* ]; then
		echo -e $green"[*] Source Exist ! :)"$netral
		source_exist=1
	else
		echo -e $yellow"[#] Warning! Source kernel didn't exist!"
		echo -e $yellow"[#] Put it in source folder!"
		echo -e $yellow"[#] Example: source/j4ltejx"$netral
		echo ""
		source_exist=0
	fi
}

# Install GCC 4.9
function install_gcc_49() {
	command -v add-apt-repository &> /dev/null || {
		echo -e $yellow"[#] Seems like software-properties-common not installed! Installing..."$netral
		sudo apt install software-properties-common -y &> /dev/null
	}
	echo -e $green"[*] Adding xenial repo..."
	sudo add-apt-repository "deb http://ports.ubuntu.com/ubuntu-ports xenial main restricted universe multiverse"
	sudo add-apt-repository "deb http://ports.ubuntu.com/ubuntu-ports xenial-security main restricted universe multiverse"
	sudo add-apt-repository "deb http://ports.ubuntu.com/ubuntu-ports xenial-updates main restricted universe multiverse"
	sudo add-apt-repository "deb http://ports.ubuntu.com/ubuntu-ports xenial-backports main restricted universe multiverse"
	echo -e $green"[*] Updating..."
	sudo apt update &> /dev/null
	echo -e $green"[*] Installing GCC 4.9..."
	sudo apt install gcc-4.9 g++-4.9 -y &> /dev/null
	echo -e $green"[*] Done!"$netral
	menu_home
}

# Install required packages
function install_dependencies() {
	echo -e $green"[*] Installing required packages..."
	sudo apt update &> /dev/null
	sudo DEBIAN_FRONTEND=noninteractive apt install bison build-essential curl flex git gnupg gperf liblz4-tool libncurses5-dev libsdl1.2-dev libxml2 libxml2-utils lzop pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev build-essential libncurses5-dev bzip2 git python -y &> /dev/null
	sleep 2
	echo -e $green"[*] Done!"
	sleep 3
	clear && menu_home
}

# Build with GCC without output (Samsung)
function build_gcc_no_output() {
	make clean && make mrproper
	make $defconfig
	make -j$(nproc --all)
}

# Build with GCC output (Xiaomi, Poco, and other)
function build_gcc_with_output() {
	make clean && make mrproper
	make $defconfig O=output
	make -j$(nproc --all)
}

# Build with Clang without output (Samsung)
function build_clang_no_output() {
	make clean && make mrproper
	make $defconfig CC=clang CROSS_COMPILE= CROSS_COMPILE_ARM32=arm-linux-gnueabi- CLANG_TRIPLE=
	make -j$(nproc --all) CC=clang CROSS_COMPILE= CROSS_COMPILE_ARM32=arm-linux-gnueabi- CLANG_TRIPLE=
}

# Build with Clang output (Xiaomi, Poco, and other)
function build_clang_with_output() {
	make clean && make mrproper
	make $defconfig CC=clang CROSS_COMPILE= CROSS_COMPILE_ARM32=arm-linux-gnueabi- CLANG_TRIPLE= O=output
	make -j$(nproc --all) CC=clang CROSS_COMPILE= CROSS_COMPILE_ARM32=arm-linux-gnueabi- CLANG_TRIPLE= O=output
}

# List all of the defconfig
function list_defconfig() {
	echo -e $green"[*] List All Defconfig:"$netral
	echo ""
	find arch/$ARCH/configs -type f
	echo ""
	if [ -d arch/$ARCH/configs/ ]; then
	echo ""
	for folder_defconfig in arch/$ARCH/configs/*/ ; do
		echo -e $green"[*] Defconfig in $folder_defconfig folder:"
		echo ""
	done
	fi
	echo -en $green"[-] Select defconfig (enter foldername if the defconfig is in folder) : "
	read defconfig
}

# Now, the final, menu home
function menu_home() {
	clear
	echo -e $green ""
	echo -e " _____			      _ _"
	echo -e "/ ____|                     (_) |"
	echo -e "| |     ___  ________  _ __  _| | ___ _ __"
	echo -e "| |    / _ \|  _   _ \|  _ \| | |/ _ \  __|"
	echo -e "| |___| (_) | | | | | | |_) | | |  __/ |"
	echo -e " \_____\___/|_| |_| |_|  __/|_|_|\___|_|"
	echo -e "                      | |"
	echo -e "                      |_|"
	echo ""
	echo ""
	echo -e $yellow"By Kali NetHunter Indonesian Group"$netral
	echo ""
	detect_source_exist
	echo ""
	if [ $source_exist == 1 ]; then
		echo -e $blue"[1] Build"
	else
		echo -e $blue"[1] Build (NOT AVAILABLE UNTIL SOURCE EXIST)"
	fi
	echo -e $netral""
	echo -e $blue"[2] Install Dependencies"
	echo ""
	echo "[3] Install GCC 4.9"
	echo ""
	echo -e "[4] Exit"$netral
	echo ""
	echo -en $yellow"[-] Choose an option: "
	read menu_option
	if [ "$menu_option" == 1 ]; then
		clear
		build_menu
	elif [ "$menu_option" == 2 ]; then
		clear
		install_dependencies
		menu_home
	elif [ "$menu_option" == 3 ]; then
		clear
		install_gcc_49
		menu_home
	elif [ "$menu_option" == 4 ]; then
		echo -e $green"Okay... Bye bye!"$netral
		sleep 2
		exit
	else
		echo -e $red"Wrong input!"$netral
		sleep 3
		menu_home
	fi
}

menu_home
sleep 2
