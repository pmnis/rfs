#!/bin/bash

SUFFIXE=$(cat config/version.cfg 2>/dev/null)
[[ $SUFFIXE ]] || SUFFIXE=$(uname -r)
RFS=${1:-rfs00.gz}

echo $RFS
shift

qemu-system-x86_64 \
     -machine pc,accel=kvm \
     -enable-kvm -smp 4 -m 1G \
     -kernel /boot/vmlinuz-${SUFFIXE} \
     -initrd ${RFS} \
     -append "console=ttyS0 numa=fake=4*256M," \
     -nographic $*

# To add a virtio network
# -netdev tap,id=mynet0
# -device virtio-net-pci,netdev=mynet0
# in the guest modprobe virtio-net

# To add a virtio block device
# -blockdev driver=file,filename=disk0.raw,node-name=drv0
# -device virtio-blk,drive=drv0
# in the guest modprobe virtio-blk
     -append "console=ttyS0 numa=on numa=noacpi numa=nohmat numa=fake=128M " \
     -numa node,cpus=0-1,nodeid=0 \
     -numa node,cpus=2-3,nodeid=1 \
     -numa node,cpus=4-7,nodeid=2 \
