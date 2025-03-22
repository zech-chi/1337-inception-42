#!/bin/sh

mkdir -p /run/php/

wget https://wordpress.org/latest.tar.gz -P /var/www/

tar -xzf /var/www/latest.tar.gz -C /var/www/html/ --strip-components=1

rm -rf /var/www/latest.tar.gz

chown -R www-data:www-data /var/www/html

# Download WP-CLI
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# sleep waiting fro mariadb
sleep 25
				
cd /var/www/html

DB_PASSWORD="$(cat /run/secrets/db_password)"
echo "--->db_password $DB_PASSWORD"
WP_ADMIN_PASSWORD="$(cat /run/secrets/wp_admin_password)"
echo "--->wp_admin_password $WP_ADMIN_PASSWORD"
WP_USER_PASSWORD="$(cat /run/secrets/wp_user_password)"
echo "--->wp_user_password $WP_USER_PASSWORD"


wp config create --allow-root \
                 --dbname="$SQL_DATABASE" \
                 --dbuser="$SQL_USER" \
                 --dbpass="$DB_PASSWORD" \
                 --dbhost="mariadb:3306"

wp core install --allow-root \
                --url="https://0.0.0.0:8080/" \
                --title="Inception" \
                --admin_user="$WP_ADMIN_LOGIN" \
                --admin_password="$WP_ADMIN_PASSWORD" \
                --admin_email="$WP_ADMIN_EMAIL"

wp user create --allow-root "$WP_USER_LOGIN" "$WP_USER_EMAIL" \
               --role=author \
               --user_pass="$WP_USER_PASSWORD"


# for redis cache
wp plugin install redis-cache --allow-root
wp config set WP_REDIS_HOST redis --allow-root
wp config set WP_REDIS_PORT 6379 --allow-root
wp plugin activate redis-cache --allow-root
wp redis enable --allow-root

# Fix PHP-FPM socket configuration
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Set correct ownership again
chown -R www-data:www-data /var/www/html

chmod 777 /var/www/html

echo "Starting WordPress in the foreground..."
exec php-fpm7.4 -F