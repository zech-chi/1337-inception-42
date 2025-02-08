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

# Ensure correct ownership of MySQL directory
chown -R mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

# Start MariaDB in the background
service mariadb start

echo "Waiting for MariaDB to start..."
until mysqladmin ping --silent; do
    sleep 2
done
echo "MariaDB is up!"

# Secure MariaDB Setup
# mysql -uroot -e "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\`;"
# mysql -uroot -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
# mysql -uroot -e "GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO '$SQL_USER'@'%';"
# mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';"
# mysql -uroot -e "FLUSH PRIVILEGES;"
# mysqladmin -uroot -p"$SQL_ROOT_PASSWORD" shutdown


mysql -e "CREATE DATABASE IF NOT EXISTS $SQl_DATABASE;"
mysql -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $SQl_DATABASE.* TO '$SQL_USER'@'%';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -u root -p$SQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

echo "Starting MariaDB in the foreground..."
exec mysqld_safe
