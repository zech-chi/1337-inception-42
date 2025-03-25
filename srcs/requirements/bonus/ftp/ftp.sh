#!/bin/sh

# create user
useradd -m "$FTP_USER"

# get password
FTP_PASS="$(cat /run/secrets/ftp_password)"
# add password
echo "$FTP_USER:$FTP_PASS" | chpasswd

# Create the required directory for secure_chroot_dir 
# for jailed (chrooted) FTP users (for security reasons)
mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

echo "Starting FTP in the foreground..."
# vsftpd: secure FTP server that allows clients to connect and transfer files
vsftpd /etc/vsftpd.conf
