#!/bin/bash

######################################################
# simple helpers to handle verbosity and errors

my_print()
{
	[[ $VERBOSE ]] && echo $*
}

error()
{
	echo $*
	exit 1
}

my_cat()
{
	[[ -r $1 ]] || return
	while read line
	do
		[[ ${line:0:1} == "#" ]] && continue
		printf "%s\n" $line
	done < $1
}

######################################################
# General definitions
# VERSION, FILE list and module list are read from config directory

TMPDIR="TMP_$$"
VERSION=$(my_cat config/version.cfg)
[[ $VERSION ]] || VERSION=$(uname -r)
FILES=$(my_cat config/files.cfg)
MODLIST=$(my_cat config/modules.cfg)

typeset -i num=0

######################################################
# functions to build the root file system in temporary directory.

# Retrieve libraries for the binary given as argument
copy_libs()
{
	typeset -l f=$1

	my_print searching libs for $f
	for l in $(ldd $f | cut -d" " -f3 )
	do
		my_print $l
		mkdir -p ${TMPDIR}/$(dirname $l)
		rsync -L $l ${TMPDIR}/$(dirname $l)/
	done
	mkdir -p ${TMPDIR}/lib/
	for f in /lib/ld.so.1 /lib/ld64.so.1; do
		[[ -e "$f" ]] && cp "$f" ${TMPDIR}/lib/
	done
}

# retrieve files from the local file system and copy to target
copy_files()
{
	for f in ${FILES}
	do
		my_print copy_files ${f}
		dname=$(dirname ${f})
		mkdir -p ${TMPDIR}/${dname}
		cp ${f} ${TMPDIR}/${dname}/
		if file -b ${f} | grep -q dynamically 
		then
			copy_libs $f
		fi
	done
}

# retrieve modules from local file system and copy to target
copy_modules()
{
	my_print copy_modules for kernel ${VERSION}

	for m in ${MODLIST}
	do
		mm=$(find /lib/modules/${VERSION}/ -name ${m}.ko*)
		if [[ ! -f $mm ]]; then
			my_print "$mm: " "module " $m.ko " not found"
		else
			my_print installing module $mm
			DST=${TMPDIR}/$(dirname $mm)
			mkdir -p ${DST}
			rsync -a $mm ${DST}/
		fi
	done
	[[ -d ${TMPDIR}/lib/modules/${VERSION} ]] && { (
	cd ${TMPDIR}/lib/modules/${VERSION};
	find . -name "*.ko*" > modules.order
	touch modules.builtin
	)
	depmod -a -b ${TMPDIR} ${VERSION}
	}
}

# copy the skeleton from RFS to temporary directory
copy_rfs()
{
	my_print copy_rfs
	rsync -a RFS/ ${TMPDIR}
	my_print create proc,sys,dev,tmp and console
	DIRS="proc sys dev tmp mnt root var/run var/log var/empty/sshd/ home/demo"
	for dir in ${DIRS}
	do
		mkdir -p ${TMPDIR}/${dir}
	done
}

# Find and copy busybox for a native setup
native_bb()
{
	bb=$(which busybox)
	[[ -x ${bb} ]] || {
		my_print "You need busybox on your system"
		my_print "Please install"
		exit 1
	}
	rsync -a native_links/ ${TMPDIR}/
	cp ${bb} ${TMPDIR}/bin
}

cross_bb()
{
	my_print "Using busybox out of $BUSYBOX_DIR"
	[[ -d ${BUSYBOX_DIR}/_install ]] || {
		my_print "You need busybox sources on your system"
		my_print "Could not find them in ${BUSYBOX_DIR}"
		my_print "Please compile and run make install"
		exit 1
	}
	rsync -a ${BUSYBOX_DIR}/_install/ RFS/
	mv RFS/linuxrc RFS/init
}

######################################################
### MAIN ###

case $1 in
	"clean")
		rm -rf TMP_*
		rm -f rfs??.gz
		rm -f rfs_ext2_*
		exit 0
		;;
esac

[[ -d ${TMPDIR} ]] && {
	my_print "You may want to erase the ${TMPDIR} directory first."
	exit 1
}

mkdir -p ${TMPDIR}


[[ -d $BUSYBOX_DIR ]] || native_bb
[[ -d $BUSYBOX_DIR ]] && cross_bb

copy_rfs
copy_modules
copy_files
# copy extra files to root filesystem
[[ -d extra ]] && rsync -a extra/ ${TMPDIR}

######################################################
# The temporary directory is now filled.
# setup the rights right
#
[[ -f ${TMPDIR}/etc/ssh ]] && chmod -R 600 ${TMPDIR}/etc/ssh
[[ -f ${TMPDIR}/etc/shadow ]] && chmod 600 ${TMPDIR}/etc/shadow

# Go on by building the initrd file out of it.

file=$(printf "rfs%02d.gz" $num)
while [[ -e $file ]]
do
        (( num++ ))
        file=$(printf "rfs%02d.gz" $num)
done
my_print "building root file system as " $file
(
cd ${TMPDIR}
find . | cpio --quiet -oH newc | gzip > ../$file
)


# if you are here, it better have worked.
echo "Success."
echo "Your ${file} file is ready to be use"
echo "You may now want to erase the ${TMPDIR} directory."
exit 0
