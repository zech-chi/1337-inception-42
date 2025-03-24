#!/bin/sh

echo "Start MariaDB service"

# Set permissions for MariaDB data directory
chown -R mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

# /run/mysqld used for the MySQL socket
mkdir -p /run/mysqld
# Change the ownership to user mysql
chown -R mysql:mysql /run/mysqld

service mariadb start

echo "Waiting for MariaDB to start..."
sleep 10
echo "MariaDB is up!"

# get passwords
DB_PASSWORD="$(cat /run/secrets/db_password)"
DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"

# create database
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\`;"
# create user and grants it all privileges 
mysql -uroot -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO '$SQL_USER'@'%';"

# create root user
mysql -uroot -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
# grants it full privileges.
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
# for local connections.
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"

# Applies the changes to the privileges
mysql -uroot -p"$DB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
# Gracefully shuts down the MariaDB server
mysqladmin -uroot -p"$DB_ROOT_PASSWORD" shutdown

echo "Starting MariaDB in the foreground..."
# keeps running mysqld_safe as the main process in the container.
exec mysqld_safe