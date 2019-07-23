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
