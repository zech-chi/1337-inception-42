#!/bin/sh

# it is used by php-fpm to store socket files.
# php-fpm : FastCGI Process Manager
mkdir -p /run/php/

# download the latest version of wordpress into the /var/www/
wget https://wordpress.org/latest.tar.gz -P /var/www/

# extracts the WordPress files from the .tar.gz archive into the /var/www/html/
# --strip-components=1 : remove /wordpress ( from /var/www/html/wordpress to /var/www/html/ )
tar -xzf /var/www/latest.tar.gz -C /var/www/html/ --strip-components=1

rm -rf /var/www/latest.tar.gz

# chown: change ownership
# -R   : recursive
# making sure that only the web server and other authorized processes have control over the web files, 
# and it also minimizes the risk of unauthorized access.
chown -R www-data:www-data /var/www/html

# download the WP-CLI (WordPress Command Line Interface) tool.
# for managing and interacting with WordPress website
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# makes it executable.
chmod +x wp-cli.phar
# moves it to /usr/local/bin/ : so it can be used globally by the system.
mv wp-cli.phar /usr/local/bin/wp

# sleep waiting fro mariadb
# I hope 25 seconds is enough.
sleep 25
				
cd /var/www/html

# get passwords from /run/secrets!
DB_PASSWORD="$(cat /run/secrets/db_password)"
WP_ADMIN_PASSWORD="$(cat /run/secrets/wp_admin_password)"
WP_USER_PASSWORD="$(cat /run/secrets/wp_user_password)"

# Generate WordPress Configuration File (wp-config.php)
wp config create --allow-root \
                 --dbname="$SQL_DATABASE" \
                 --dbuser="$SQL_USER" \
                 --dbpass="$DB_PASSWORD" \
                 --dbhost="mariadb:3306"

# Install WordPress Core
wp core install --allow-root \
                --url="https://$DOMAIN_NAME" \
                --title="Inception1337" \
                --admin_user="$WP_ADMIN_LOGIN" \
                --admin_password="$WP_ADMIN_PASSWORD" \
                --admin_email="$WP_ADMIN_EMAIL"

# Create a WordPress User
wp user create --allow-root "$WP_USER_LOGIN" "$WP_USER_EMAIL" \
               --role=author \
               --user_pass="$WP_USER_PASSWORD"


# Updates the home and siteurl options to match the provided domain name.
wp option update home "https://$DOMAIN_NAME" --allow-root
wp option update siteurl "https://$DOMAIN_NAME" --allow-root

# Activates the default WordPress theme
wp theme activate twentytwentyfour --allow-root

# Install and Configure Redis Cache
wp plugin install redis-cache --allow-root
wp config set WP_REDIS_HOST redis --allow-root
wp config set WP_REDIS_PORT 6379 --allow-root
wp plugin activate redis-cache --allow-root
wp redis enable --allow-root

# Modifies the PHP-FPM configuration to use port 9000 instead of a Unix socket.
# to allow communication over TCP or between Docker containers (nginx container).
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Set correct ownership again
chown -R www-data:www-data /var/www/html

chmod 777 /var/www/html

echo "Starting WordPress in the foreground..."
# exec      : replace current proccess with new one (sh --> php-fpm),
# to keep this container running main process (php-fpm)
# php-fpm7.4: PHP FastCGI Process Manager --> to serve PHP applications
# -F        : in foreground
exec php-fpm7.4 -F