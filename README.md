# QEMU-virtual-disks-manager

Simple Bash utility script to manage multiple QEMU virtual hard drives within one folder.

Script detects all drives in folder ending with *.qcow2 then asks what type of system is it (win or linux).

Modular construction and usage of switch statement allows to adopt script for personal needs in case someone (like me) maintains multiple virtual machines on disk and may need to adjust different options for different machines.

Currently it makes no difference which type You choose but I've left an opportunity to easily extend functionality.
