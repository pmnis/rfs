#!/bin/sh

sudo qemu-system-x86_64 \
     -enable-kvm -smp 2 -m 512 \
     -machine pc,accel=kvm \
     -kernel /boot/vmlinuz \
     -initrd rfs00.gz \
     -append "console=ttyS0 " \
     \
     -blockdev driver=file,filename=disk0.raw,node-name=drv0 \
     -device virtio-blk,drive=drv0 \
     \
     -nographic
