#!/bin/bash

# exit at first error 
set -euo pipefail

if [[ $# -lt 2 ]]; then
   echo "E: specify MCC version and Debian suite to build"
   exit 1
fi

MCC_VERSION=$1
SUITE=$2
OUTDIR_SUFFIX=images

case "$SUITE" in
   bookworm)
      VERSION=12
      ;;
   trixie)
      VERSION=13
      ;;
   *)
      echo "E: suites available: bookworm, trixie"
      exit
      ;;
esac

case "$MCC_VERSION" in
   v1)
      ;;
   v2)
      ;;
   *)
      echo "E: MCC versions available: v1, v2"
      exit
      ;;
esac


OUTDIR=${OUTDIR_SUFFIX}/${SUITE}

mkdir -p ${OUTDIR}

echo "suite: ${SUITE}"
echo "outdir: ${OUTDIR}"

###

PL_PROJECT_BASE=~/devel/HyperK/PROD-MCC/petalinux/pl-mcc-${MCC_VERSION}/images/linux
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
sudo debos \
   -t outdir:${OUTDIR} \
   -t version:${VERSION} \
   -t suite:${SUITE} \
   -t image:zynqmp-mcc-debian-${SUITE}.img \
   -t mcc_version:${MCC_VERSION} \
   --cpus=8 \
   --disable-fakemachine debimage-zynqmp-mcc.yaml

sudo losetup -D

sudo chown -R ${USER}:${USER} ${OUTDIR_SUFFIX}

echo "Bye!"
