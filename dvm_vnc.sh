#!/bin/sh

qemu-system-x86_64 -kernel /boot/vmlinuz -initrd rfs00.gz -vnc 192.168.1.101:10 -monitor stdio

