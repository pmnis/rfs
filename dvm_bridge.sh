#!/bin/sh

sudo qemu-system-x86_64 \
     -enable-kvm -smp 2 -m 512 \
     -machine pc,accel=kvm \
     -kernel /boot/vmlinuz \
     -initrd rfs00.gz \
     -append "console=ttyS0 " \
     \
     -netdev bridge,id=br1 \
     -device virtio-net,netdev=br1,mac=52:54:00:12:34:51 \
     \
     -nographic
