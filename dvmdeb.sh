#!/bin/sh

sudo qemu-system-x86_64 \
     -enable-kvm -smp 2 -m 512 \
     -machine pc,accel=kvm \
     -cdrom ../../VM/debian-11.2.0-amd64-netinst.iso  \
     $*
