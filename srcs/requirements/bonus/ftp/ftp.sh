#!/bin/sh

useradd -m "$FTP_USER"

FTP_PASS="$(cat /run/secrets/ftp_password)"
echo "$FTP_USER:$FTP_PASS" | chpasswd

# Create the required directory for secure_chroot_dir
mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

echo "Starting FTP in the foreground..."
vsftpd /etc/vsftpd.conf
