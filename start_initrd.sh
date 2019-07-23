#!/bin/bash

SUFFIXE=$(cat config/version.cfg 2>/dev/null)
[[ $SUFFIXE ]] || SUFFIXE=$(uname -r)
RFS=${1:-rfs00.gz}

echo $RFS
shift

qemu-system-x86_64 \
     -machine pc,accel=kvm \
     -enable-kvm -smp 2 -m 512 \
     -kernel /boot/vmlinuz-${SUFFIXE} \
     -initrd ${RFS} \
     -append "console=ttyS0 " \
     -nographic $*

# To add a virtio network
# -netdev tap,id=mynet0
# -device virtio-net-pci,netdev=mynet0

# To add a virtio block device
# -blockdev driver=file,filename=disk0.raw,node-name=drv0
# -device virtio-blk,drive=drv0
