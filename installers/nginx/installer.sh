#!/bin/sh
      

CURL_CMD=$(which curl) 
YUM_CMD=$(which yum) 
DNF_CMD=$(which dnf) 
APT_GET_CMD=$(which apt-get) 
PACMAN_CMD=$(which pacman) 
APK_CMD=$(which apk) 
GIT_CMD=$(which git) 

SUDO_CMD=$(which sudo) 

USER="$(id -un 2>/dev/null || true)"
SUDO=''
if [ "$USER" != 'root' ]; then
	if [ ! -z $SUDO_CMD ]; then
		SUDO='sudo'
	else
		cat >&2 <<-'EOF'
		Error: this installer needs the ability to run commands as root.
		We are unable to find "sudo". Make sure its available to make this happen
		EOF
		exit 1
	fi
fi

RESET='[0m'
RED='[0;31m'
GREEN='[0;32m'
YELLOW='[0;33m'
log () {
 echo "[`date "+%Y.%m.%d-%H:%M:%S%Z"`]$1 $2"
}
info () {
 log "$GREEN INFO$RESET $1"
}
warn () {
 log "$YELLOW WARN$RESET $1"
}
error () {
 log "$RED ERROR$RESET $1"
}

if [ ! -z $DNF_CMD ]; then
   $SUDO dnf install nginx
   
elif [ ! -z $PACMAN_CMD ]; then
   $SUDO pacman -S nginx
   
elif [ ! -z $APT_GET_CMD ]; then
   $SUDO apt-get update
   $SUDO apt-get install nginx
   
elif [ ! -z $APK_CMD ]; then
   $SUDO apk update
   $SUDO apk add nginx
   
elif [ ! -z $YUM_CMD ]; then
   $SUDO yum install nginx
   
else
   echo "Couldn't install package"
   exit 1;
fi