#!/bin/sh

sudo /usr/bin/qemu-system-x86_64 \
     -enable-kvm -smp 2 -m 512 \
     -machine pc,accel=kvm \
     -kernel /boot/vmlinuz \
     -initrd rfs00.gz \
     -append "console=ttyS0 " \
     \
     -fsdev local,id=dev9p,path=/home/pmorel/9p,security_model=none \
     -device virtio-9p-pci,fsdev=dev9p,mount_tag=mount_1 \
     \
     -nographic


in the guest:
 # modprobe 9p
[    7.102545] 9pnet: Installing 9P2000 support
[    7.113678] FS-Cache: Loaded
[    7.120316] 9p: Installing v9fs 9p2000 file system support
[    7.122468] FS-Cache: Netfs '9p' registered for caching
/ # modprobe 9pnet-virtio

/ # lsmod
Module                  Size  Used by    Not tainted
9pnet_virtio           20480  0 
9p                     61440  0 
fscache               380928  1 9p
9pnet                  86016  2 9pnet_virtio,9p
/ # 

# mount -t 9p mount_1 /mnt/


Pour libvirt:

 <filesystem type='mount' accessmode='passthrough'>
   <source dir='/home/usera/9p_share'/>
   <target dir='mount_1'/>
 </filesystem>

