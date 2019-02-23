#!/bin/bash

SUFFIXE=$(cat config/version.cfg)
RFS=${1:-rfs00.gz}

echo $RFS
shift

sudo /usr/local/bin/qemu-system-s390x \
     -machine s390-ccw-virtio,accel=kvm \
     -enable-kvm -smp 1 -m 512 \
     -netdev tap,id=hn0,queues=1 \
     -device virtio-net-ccw,netdev=hn0,mq \
     -kernel /boot/vmlinuz-${SUFFIXE} \
     -initrd ${RFS} \
     -append "loglevel=8 selinux=0 root=/dev/ram" \
     -nographic $*
