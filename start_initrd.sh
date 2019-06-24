#!/bin/bash

SUFFIXE=$(cat config/version.cfg)
RFS=${1:-rfs00.gz}

echo $RFS
shift

qemu-system-x86_64 \
	-machine pc,accel=kvm \
	-enable-kvm -smp 2 -m 1G \
	-netdev tap,id=hn0,queues=1 \
	-device virtio-net,netdev=hn0,mq \
	-drive id=drv0,file=dsk0,format=raw,if=none \
	-device virtio-blk,drive=drv0,id=dev0 \
	-kernel /boot/vmlinuz-${SUFFIXE} \
	-initrd ${RFS} \
	-append "console=ttyS0" \
	-nographic $*
