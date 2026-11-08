#!/bin/sh

docker run --rm -v $ARTIFACTDIR/overlays/staging:/staging ghcr.io/gtortone/debian-cross-arm:$1 \
sh -c '
cd /opt
git clone https://github.com/gtortone/libToolDAQ.git
cd libToolDAQ

TFC_REPO_TAG=ed687ea
TDF_REPO_TAG=ca5d429
TDI_REPO_TAG=9983067

cmake -B build-arm64 -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-aarch64-linux-gnu.cmake \
   -DTFC_REPO_TAG=$TFC_REPO_TAG -DTDF_REPO_TAG=$TDF_REPO_TAG -DTDI_REPO_TAG=$TDI_REPO_TAG \
   -DCMAKE_INSTALL_PREFIX=/ -DCMAKE_INSTALL_LIBDIR=/lib
make -j -C build-arm64
make -C build-arm64 DESTDIR=/staging install

rm -rf build-arm64

cmake -B build-arm64 -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-aarch64-linux-gnu.cmake \
   -DTFC_REPO_TAG=$TFC_REPO_TAG -DTDF_REPO_TAG=$TDF_REPO_TAG -DTDI_REPO_TAG=$TDI_REPO_TAG
make -j -C build-arm64
make -C build-arm64 install

mkdir -p /staging/opt
cd /staging/opt
git clone https://git.hyperk.org/hyperk-online/mpmt/mcc-daq-interface.git
cd mcc-daq-interface

cmake -B build-arm64 -DCMAKE_TOOLCHAIN_FILE=/opt/libToolDAQ/cmake/toolchain-aarch64-linux-gnu.cmake
make -j -C build-arm64
'
