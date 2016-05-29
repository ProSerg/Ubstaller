#!/bin/bash

sudo chroot ./live/chroot dpkg-query -W --showformat='${Package} ${Version} \n' | sudo tee image/casper/filesystem.manifest
sudo cp -v image/casper/filesystem.manifest image/casper/filesystem.manifest-desktop
REMOVE='ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover xresprobe os-prober libdebian-installer4'
for i in $ REMOVE
do
	sudo sed -i "/${i}/d" image/casper/filesystem.manifest-desktop
done
