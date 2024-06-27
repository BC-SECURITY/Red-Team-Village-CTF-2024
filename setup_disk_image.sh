#!/bin/bash

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Create and configure disk image with a hidden flag
dd if=/dev/zero of=/home/spartan/disk.img bs=1M count=1
mkfs.ext4 /home/spartan/disk.img
mkdir /mnt/disk
mount /home/spartan/disk.img /mnt/disk
echo "flag{5007e994724962398cb5634b8bbbdbf2}" > /mnt/disk/hidden_flag.txt
umount /mnt/disk
rmdir /mnt/disk
