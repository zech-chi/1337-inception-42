#!/bin/sh

echo "Start MariaDB service"

if [ -z "$SQL_DATABASE" ] || [ -z "$SQL_USER" ] || [ -z "$SQL_PASSWORD" ] || [ -z "$SQL_ROOT" ] || [ -z "$SQL_ROOT_PASSWORD" ]; then
    echo "Error: Required environment variables are missing!"
    exit 1
fi

echo "Database      : $SQL_DATABASE"
echo "User          : $SQL_USER"
echo "Password      : $SQL_PASSWORD"
echo "Root User     : $SQL_ROOT"
echo "Root Password : $SQL_ROOT_PASSWORD"

chown -R mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

service mariadb start

echo "Waiting for MariaDB to start..."
sleep 10
echo "MariaDB is up!"

# Create database and user
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\`;"
mysql -uroot -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO '$SQL_USER'@'%';"

# Allow root access from any host
mysql -uroot -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Flush privileges and restart
mysql -uroot -p"$SQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
mysqladmin -uroot -p"$SQL_ROOT_PASSWORD" shutdown

echo "Starting MariaDB in the foreground..."
exec mysqld_safe