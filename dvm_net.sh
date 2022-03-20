#!/bin/sh

sudo qemu-system-x86_64 \
     -enable-kvm -smp 2 -m 512 \
     -machine pc,accel=kvm \
     -kernel /boot/vmlinuz \
     -initrd rfs00.gz \
     -append "console=ttyS0 " \
     \
     -netdev tap,id=mynet0 \
     -device virtio-net,netdev=mynet0 \
     \
     -nographic
