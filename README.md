# rfs
Easy Root File System generation for embedded systems or Virtualization


- Abstract

This tool is based on busybox and is intended to work on a S390 host.
It produces two target. initrd for simple use and an ext2 rootfile system
in case one wants to have persistant data.


- Usage

First you will need busybox, you can find it on https://busybox.net/
(or on tuxmaker).
You will certainly prefer to build it as a static binary or you will
need to copy the libraries yourself.

build_me.sh will build a root file system in two steps:
 1) gather the files inside a temporary directory
 2) use this directory to build an initrd and an ext2 rootfs

To do this build_me.sh takes informations from files in the
config/ directory and use the skeleton in RFS/ directory.

build_me.sh should work without any change in configuration
when retrieved from git repository with predefined configuration.
just start it as ./build_me.sh

You can add your own file tree inside extra/ and you find specific
guest modules inside modules/.

You can easily adapt the skeleton to your needs and in particular
add users in etc/passwd or start programs in etc/rc or etc/inittab.

- Starting QEMU

To use just do:

 ./build_me.sh

 ./start_initrd.sh


- Files in this directory

build_me.sh.....: To build the root fs

README..........: This file

start_ext2.sh...: starting the rootfs on a virtio_blk drive

start_initrd.sh.: starting the rootfs in an initrd

- Special directories

RFS.............: The directory with the skeleton

extra...........: your own files should go there and will be copied
                  to the guest Root file system

modules.........: A directory holding Linux modules for the guest+

config..........: The configuration directory (see here under)

- Configuration in the config directory

disk_size.cfg...: the size of the ext2 partition

files.cfg.......: The list of files to copy on rootfs

modules.cfg.....: The list of modules to copy on rootfs

version.cfg.....: the version of kernel and modules to use


