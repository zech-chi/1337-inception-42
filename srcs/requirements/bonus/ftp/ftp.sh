#!/bin/sh

# cp /etc/vsftpd.conf /etc/vsftpd.conf.original

# useradd -m -s /bin/bash zech
useradd -m zech
echo "zech:zechpass" | chpasswd

# mkdir -p /home/zech/data
# Create the required directory for secure_chroot_dir
mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

# service vsftpd start

echo "ftp in foreground"
exec vsftpd /etc/vsftpd.conf
echo "ftp in foreground"