#!/bin/bash

# Create a raw disk image
qemu-img create -f raw /home/spartan/disk.img 1M

# Create a temporary directory for the filesystem
mkdir /tmp/fs

# Create the flag file
echo "flag{5007e994724962398cb5634b8bbbdbf2}" > /tmp/fs/hidden_flag.txt

# Create the filesystem image with the contents of /tmp/fs
virt-make-fs --type=ext4 /tmp/fs /home/spartan/disk.img

# Clean up
rm -rf /tmp/fs
rm -rf /usr/local/bin/setup_disk_image.sh