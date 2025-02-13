#!/bin/sh
mkdir -p /var/www/html/adminer

cd /var/www/html/adminer

curl -L -o adminer.php https://github.com/vrana/adminer/releases/download/v4.7.8/adminer-4.7.8.php

echo "Starting Adminer in the foreground..."

php -S 0.0.0.0:8080