#!/bin/bash

mkdir -p ./image
mkdir -p ./live/chroot

if [ `id -u` -ne 0 ]; then		
	echo "Данный скрипт запускается только из под учетной записи root"
	exit 1
fi

ARCH=amd64
RELEASE=trusty ##edgy, gutsy, hardy
DIR=chroot
MIRROR=http://archive.ubuntu.com/ubuntu

cd ./live
echo "debootstrap --arch $ARCH $RELEASE $DIR $MIRROR"
debootstrap --arch $ARCH $RELEASE $DIR $MIRROR

