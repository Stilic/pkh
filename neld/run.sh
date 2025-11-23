#!/bin/sh
cd .build/work
exec qemu-system-x86_64 -accel kvm -kernel vmlinuz -initrd ramdisk.cpio.gz -smp 12 -m 12G -drive file=disk,format=raw,if=virtio -nographic -append "quiet console=ttyS0 root=/dev/vda"
