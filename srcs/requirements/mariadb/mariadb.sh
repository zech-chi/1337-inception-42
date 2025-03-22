#!/bin/sh

echo "Start MariaDB service"

chown -R mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

service mariadb start

echo "Waiting for MariaDB to start..."
sleep 10
echo "MariaDB is up!"

mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\`;"
mysql -uroot -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO '$SQL_USER'@'%';"

mysql -uroot -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

mysql -uroot -p"$SQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
mysqladmin -uroot -p"$SQL_ROOT_PASSWORD" shutdown

echo "Starting MariaDB in the foreground..."
exec mysqld_safe