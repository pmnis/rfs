# rfs
Easy Root File System generation for embedded systems or Virtualization


## Abstract

This tool is based on busybox and is intended to work on a Linux.
It produces two target: initrd for simple use and an ext2 rootfile system
in case one wants to have persistant data.


## Usage

### build_me.sh

First you will need busybox, you can find it on https://busybox.net/
(or on tuxmaker).
You will certainly prefer to build it as a static binary or you will
need to copy the libraries for busybox yourself.

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

### build_me.sh clean

build_me.sh will generate an initrd and an ext2 file system with
an indice, like rfs00.gz and rfs_ext2_00, the second run will
create rfs01.gz etc.

You also will be able to review the image under the temporary directory
TMP_XXX created on build.

If you want to reset the counter and remove the temporary directories
just run:

````
# build_me.sh clean
````

### building for x86

There is a predefined busybox links tree in RFS, you will
only need to install busybox as a static program on your system
and build_me.sh will find it in the PATH.

### building for another architecture

When building for another architecture you will have to
download, configure, compile busybox.

* [busybox](http://busybox.net) - the busybox web site

Then you will install busybox in RFS directory doing:

````
# rsync -av $(BUSYBOX_PATH)/_install/ RFS/
````
You will not have to repeat this unless you modify busybox.


### Starting with QEMU

Make sure you installed busybox as static on your development
system and do:

````
# ./build_me.sh
# ./start_initrd.sh
````

## The rfs tree

### Files in this directory

* build_me.sh.....: To build the root fs
* README..........: This file
* start_ext2.sh...: starting the rootfs on a virtio_blk drive
* start_initrd.sh.: starting the rootfs in an initrd

### Special directories

* RFS.............: The directory with the skeleton
* extra...........: your own files should go there and will be copied to the guest Root file system
* modules.........: A directory holding extra Linux modules for the guest (otherwise build_me.sh looks inside /lib/modules/$(cat config/version)/
* config..........: The configuration directory (see here under)

### Configuration in the config directory

* disk_size.cfg...: the size of the ext2 partition
* files.cfg.......: The list of files to copy on rootfs
* modules.cfg.....: The list of modules to copy on rootfs
* version.cfg.....: the version of kernel and modules to use


