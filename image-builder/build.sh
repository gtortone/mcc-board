#!/bin/bash

DEBIAN_RELEASE=12
PL_PROJECT_BASE=~/devel/HyperK/PROD-MCC/petalinux/pl-mcc/images/linux
TMPDIR=$PL_PROJECT_BASE/tmp

echo "extract Linux kernel modules from PetaLinux rootfs..."
mkdir $TMPDIR
tar -C $TMPDIR -xzvf $PL_PROJECT_BASE/rootfs.tar.gz ./usr/lib/modules
tar -C $TMPDIR -czf overlays/boot/modules.tar.gz ./usr/lib 
rm -rf $TMPDIR

echo "copy PetaLinux files..."
cp $PL_PROJECT_BASE/Image overlays/boot
cp $PL_PROJECT_BASE/system.dtb overlays/boot

echo "start Linux image build..."
sudo debos -t image:zynqmp-mcc-debian$DEBIAN_RELEASE.img --cpus=8 --disable-fakemachine debimage-zynqmp-mcc.yaml

sudo losetup -D
