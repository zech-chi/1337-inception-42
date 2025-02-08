#!/bin/sh

mkdir -p /run/php/

wget https://wordpress.org/latest.tar.gz -P /var/www/

tar -xzf /var/www/latest.tar.gz -C /var/www/

rm -rf  /var/www/latest.tar.gz

mv -R /var/www/wordpress /var/www/html

chown -R www-data:www-data /var/www/html

# Download WP-CLI
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# sleep waiting fro mariadb
sleep 20
				
cd /var/www/html

wp config create --allow-root \
                 --dbname="$SQL_DATABASE" \
                 --dbuser="$SQL_USER" \
                 --dbpass="$SQL_PASSWORD" \
                 --dbhost="mariadb:3306"

# Fix PHP-FPM socket configuration
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Set correct ownership again
chown -R www-data:www-data /var/www/html

echo "Starting WordPress in the foreground..."
exec php-fpm7.4 -F