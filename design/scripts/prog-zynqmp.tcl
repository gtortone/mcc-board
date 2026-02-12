#
set pldir ~/devel/HyperK/PROD-MCC/petalinux/pl-mcc/images/linux
#

connect

# set JTAG mode
targets -set -nocase -filter {name =~ "PSU"}
mwr 0xff5e0200 0x0100
rst -system

# load bitstream
fpga -file $pldir/system.bit 
after 2000

# load PMU firmware
targets -set -filter {name =~ "PSU"}
mwr 0xffca0038 0x1ff
targets -set -filter {name =~ "MicroBlaze PMU"}
dow $pldir/pmufw.elf
con 

# load FSBL
targets -set -filter {name =~ "Cortex-A53 #0"}
rst -processor
dow $pldir/zynqmp_fsbl.elf
con
after 2000
stop

## load APP on Cortex-R5 core0
#targets -set -filter {name =~ "Cortex-R5 #0"}
#rst -processor
#dow ~/devel/HyperK/PROD-MCC/firmware/app_mccv2_r5/build/app_mcc.elf
#con

### load APP on Cortex-A53 core1
##targets -set -filter {name =~ "Cortex-A53 #1"}
##rst -processor
##dow ~/devel/HyperK/PROD-MCC/firmware/app_mcc_a53/build/app_mcc_a53.elf
##con
#
targets -set -filter {name =~ "Cortex-A53 #0"}

# load device tree
#dow -data $pldir/system.dtb 0x100000

# load BL31
dow $pldir/bl31.elf
con
after 2000
stop

## load image.ub
##dow -data $pldir/image.ub 0x2000000
#
## load BOOT.BIN
##dow -data $pldir/BOOT.BIN 0x2000000
#
# load U-Boot
dow $pldir/u-boot-dtb.elf
con



