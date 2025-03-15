FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://defconfig.cfg"
SRC_URI:append = " file://0001-Enclustra-zynqmp-board-patch.patch"
SRC_URI:append = " file://0002-Enclustra-MAC-address-readout-from-EEPROM.patch"
SRC_URI:append = " file://0003-ATSHA204A-upstream-fixes.patch"
SRC_URI:append = " file://0004-Enclustra-DS28-eeprom-fix.patch"
SRC_URI:append = " file://0005-Zynq-QSPI-patch.patch"
SRC_URI:append = " file://0006-Zynq-eMMC-patch.patch"
SRC_URI:append = " file://0007-add-default-environment.patch"

