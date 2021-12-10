# FPGA-Tank-Trouble
https://github.com/saraspahi/FPGA-Tank-Trouble <- Git repo

Instructions:
The project requires a VGA monitor and USB keyboard to be plugged in. it may be possible to skip compilation using the SOF that is included
open lab6.qpf
Open lab62_soc.qys in platform designer, and Generate HDL
Compile project (should take ~10 min)
flash with SOF
Open Nios II software tools, and import tank_trouble and tank_trouble_bsp using NIOS II C/C++ software build package
Generate BSP and clean build
Run configurations and run with NIOS II, if soc does not show up refresh connections.
If reset timeout appears in nios II console tap the USB shield
Game controls are arrow keys for the red tank and spacebar to shoot, and wasd for yellow with q to shoot.
