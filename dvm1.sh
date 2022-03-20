#!/bin/sh

qemu-system-x86_64 \
     -kernel /boot/vmlinuz \
     -initrd rfs00.gz \
     -append "console=ttyS0 " \
     -nographic
