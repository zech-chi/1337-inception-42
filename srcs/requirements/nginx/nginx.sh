#!/bin/sh
echo "create the ssl directory ..."
mkdir -p /etc/nginx/ssl

echo "create ssl certificate ..."
openssl req -x509 -nodes -newkey rsa:4096 -days 365 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=MA/ST=Khouribga/L=Khouribga/O=1337 Coding School/OU=IT Department/CN=$DOMAIN_NAME"

chmod 777 /var/www/html

sed -i "s/DOMAIN_NAME_HERE/$DOMAIN_NAME/" /etc/nginx/sites-enabled/default

echo "start nginx in the foreground ..."
nginx -g "daemon off;"
