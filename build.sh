#!/bin/bash

if [ `id -u` -ne 0 ]; then		
	echo "Данный скрипт запускается только из под учетной записи root"
	exit 1
fi

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
 # debootstrap --arch $ARCH $RELEASE $DIR $MIRROR
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

create_system() {
mount none-t proc /proc
mount none-t sysfs /sys
mount none-t devpts /dev/pts
export HOME=/etc/skel
export LC_ALL=C
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 12345678 # Substitute " 12345678 " with the PPA's OpenPGP ID.
apt-get update
apt-get install --yes dbus
dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl
}

install_app() {

###
apt-get --yes upgrade
###

## Install packages
apt-get install --yes ubuntu-standard casper lupin-casper
apt-get install --yes discover laptop-detect os-prober
apt-get install --yes linux-generic
apt-get install --yes openbox obconf obmenu

}

setup_openbox() {
###
# It need to create and edit  ~/.config/openbox/autostart
###
echo ""
}

preparation () {

###
cd /tmp # Заходим в оперативную память
cp /initrd.img ./initrd0.gz # копируем в /tmp initrd.img  
casper-new-uuid /tmp/initrd0.gz /tmp/initrd.gz /tmp/casper-uuid-generic # Создаем файлы initrd.gz и casper-uuid-generic
mkdir /tmp/tmp # создаем папку для временного хранения initramfs
cd ./tmp # входим в нее
gunzip -dc ../initrd.gz | cpio -imvd --no-absolute-filenames # распаковка gz
find . | cpio --quiet --dereference -o -H newc | lzma -7 > ../initrd.lz # упаковка в lz

###
cp -v chroot/tmp/{initrd.lz,casper-uuid-generic} .

apt-get install ubiquity-frontend-gtk

cd /
rm -rfv /tmp/*

}

do_initctl() {
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl

}

deploy
settings
#download_kernel
#copy_basefiles
chroot_in

 #backup_initctl
 #create_system
 #install_app
 #preparation
 #do_initctl

chroot_out


