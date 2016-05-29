#!/bin/bash


cd image
ln -s . ubuntu
mkdir .disk
cd .disk
cp ../../casper-uuid-generic .
touch base_installable
echo "full_cd/single"> cd_type
echo 'Ubuntu 14.04 LTS "Trusty Tahr" - Release i386 ** Remix **'> info
echo "http://ubuntu-rescue-remix.org"> release_notes_url
cd ../..
