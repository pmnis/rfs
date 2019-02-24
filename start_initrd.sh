#!/bin/bash

SUFFIXE=$(cat config/version.cfg)
RFS=${1:-rfs00.gz}

echo $RFS
shift

/usr/local/bin/qemu-system-x86_64 \
     -machine pc,accel=kvm \
     -enable-kvm -smp 2 -m 512 \
     -kernel /boot/vmlinuz-${SUFFIXE} \
     -initrd ${RFS} \
     -append "console=ttyS0 " \
     -nographic $*
