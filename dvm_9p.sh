#!/bin/sh

sudo /usr/bin/qemu-system-x86_64 \
     -enable-kvm -smp 2 -m 512 \
     -machine pc,accel=kvm \
     -kernel /boot/vmlinuz \
     -initrd rfs00.gz \
     -append "console=ttyS0 " \
     \
     -fsdev local,id=dev9p,path=/home/pmorel/9p,security_model=none \
     -device virtio-9p-pci,fsdev=dev9p,mount_tag=mount_1 \
     \
     -nographic
