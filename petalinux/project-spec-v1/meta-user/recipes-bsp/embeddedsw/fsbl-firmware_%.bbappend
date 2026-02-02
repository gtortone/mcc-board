FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

YAML_COMPILER_FLAGS:append = " -DFSBL_DEBUG "

SRC_URI:append = " file://0001-add-MCC-setup-to-FSBL-handoff.patch "
SRC_URI:append = " file://0002-add-MCC-banner.patch "
SRC_URI:append = " file://git/lib/sw_apps/zynqmp_fsbl/src "

