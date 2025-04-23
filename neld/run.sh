#!/bin/sh
exec qemu-system-x86_64 -accel kvm -kernel vmlinuz -initrd ramdisk.cpio.gz -smp 8 -m 8G -drive file=disk,format=raw,if=virtio -nographic -append "quiet console=ttyS0 root=/dev/vda"
