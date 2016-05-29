#!/bin/bash

if [ `id -u` -ne 0 ]; then		
	echo "Данный скрипт запускается только из под учетной записи root"
	exit 1
fi

apt() {

sudo apt-get install debootstrap syslinux squashfs-tools genisoimage
}

deploy() {
 mkdir -p ./image/{casper,isolinux,install}
 mkdir -p ./live/chroot
}

settings() {
 ARCH=amd64
 RELEASE=trusty ##edgy, gutsy, hardy
 DIR=chroot
 MIRROR=http://archive.ubuntu.com/ubuntu
}

download_kernel() {
 cd ./live
 echo "debootstrap --arch $ARCH $RELEASE $DIR $MIRROR"
#  debootstrap --arch $ARCH $RELEASE $DIR $MIRROR
 cd ..

}

copy_basefiles() {
 cp -r -v /etc/hosts ./live/chroot/etc/hosts
 cp -r -v /etc/resolv.conf ./live/chroot/etc/resolv.conf
 cp -r -v /etc/apt/sources.list ./live/chroot/etc/apt/sources.list 
 cp -r -v ./root/ ./live/chroot/
 cp -r -v ./root/proxy ./live/chroot/etc/apt/apt.conf.d/
}

backup_initctl() {
 mkdir -p /root/backup
 cp -r -v /sbin/initctl /root/backup/
}


chroot_in() {
 sudo mount --bind /dev ./live/chroot/dev
 sudo chroot ./live/chroot
 ls -l
}

chroot_out() {
 exit
 ls -l
 sudo umount  ./live/chroot/dev
}

setup_openbox() {
###
# It need to create and edit  ~/.config/openbox/autostart
###
echo ""
}

do_initctl() {
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl

}

copy_iamge() {
 cp -r -v ./live/chroot/boot/vmlinuz-4.2.0-36-generic ./image/casper/
}

deploy
settings
#download_kernel
copy_basefiles
chroot_in

 #backup_initctl

 #do_initctl
  copy_image
chroot_out


