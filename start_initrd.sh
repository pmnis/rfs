#!/bin/bash

SUFFIXE=$(cat config/version.cfg)
RFS=${1:-rfs00.gz}

echo $RFS
shift

/usr/local/bin/qemu-system-x86_64 \
     -machine pc,accel=kvm \
     -enable-kvm -smp 2 -m 512 \
     -netdev tap,id=hn0,queues=1 \
     -device virtio-net,netdev=hn0,mq \
     -kernel /boot/vmlinuz-${SUFFIXE} \
     -initrd ${RFS} \
     -append "console=ttyS0 " \
     -nographic $*
