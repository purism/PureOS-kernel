#!/bin/sh
set -e
clear
basedir=$(echo $PWD)

DEBEMAIL=dev@puri.sm
DEBFULLNAME="PureOS GNU/Linux developers"

# get source and cd into it.
echo "Removing previous build files..."
rm -rf linux*

echo "Obtaining sources..." 
apt-src install linux-image-4.3.0-1-amd64

echo "Patching Kernel with BYD drivers..."
cd linux*
linuxdir=$(echo $PWD)

cp $basedir/data/byd-mouse/drivers/input/mouse/* drivers/input/mouse/.
echo "CONFIG_MOUSE_PS2_BYD=y" >> debian/config/config
dch -a "BYD mouse driver."

echo "Building Kernel..."

cd $linuxdir
apt-src import linux-image-4.3.0-1-amd64 --here

cd $basedir
echo "FIRST"

# for some reason the first call fails, so call it twice...
set +e
apt-src build linux-image-4.3.0-1-amd64
set -e
apt-src build linux-image-4.3.0-1-amd64
