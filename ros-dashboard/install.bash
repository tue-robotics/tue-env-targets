#! /usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
$DIR/get-releases linux64 | $DIR/process-releases

source /etc/lsb-release


VER=$DISTRIB_RELEASE
if [ $VER = "14.04" ]
then
	if ! [ -L /usr/lib/libudev.so.0 ];
	then
		echo "I'm going to symlink libudev.so.1.3.5 to libudev.so.0"
		sudo ln -s /lib/x86_64-linux-gnu/libudev.so.1.3.5 /usr/lib/libudev.so.0
	fi
elif [ $VER = "16.04" ]
then
    if ! [ -L /lib/x86_64-linux-gnu/libudev.so.0 ]
    then
		echo "I'm going to symlink libudev.so.1 to libudev.so.0"
        sudo ln -s /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libudev.so.0
    fi
fi
