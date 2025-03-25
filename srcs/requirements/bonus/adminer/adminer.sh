#!/bin/sh

# to store the Adminer PHP file.
mkdir -p /var/www/html/adminer

cd /var/www/html/adminer

# -L for redirction purpose
# download the Adminer PHP script and saves it as index.php in the current directory (/var/www/html/adminer).
curl -L -o index.php https://github.com/vrana/adminer/releases/download/v4.7.8/adminer-4.7.8.php

echo "Starting Adminer in the foreground..."

# -S option starts PHP server
# -t option specifies the document root
php -S 0.0.0.0:8080 -t /var/www/html/adminer