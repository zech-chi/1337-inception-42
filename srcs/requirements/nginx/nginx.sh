#!/bin/sh
echo "create the ssl directory ..."
# where the ssl certificate and private key will be stored.
mkdir -p /etc/nginx/ssl

echo "create ssl certificate ..."
# openssl req: create a certificate request.
# -x509      : generate self signed certificate instead of a certificate signing request.
# -nodes     : withot needing to manually enter a password inside the container.
# -newkey rsa:4096 : create new private rsa key of size 4096 bits.
# -days 365        : valid for 365 days
# -keyout          : where the private key will be saved
# -out             : where the certificate will be saved
# -subj            : the identity of the certificate
#      C  : country
#      ST : state
#      L  : locality (city)
#      O  : organization
#      OU : organization unit
#      CN : Common Name (domain name)
openssl req -x509 -nodes -newkey rsa:4096 -days 365 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=MA/ST=Khouribga/L=Khouribga/O=1337 Coding School/OU=IT Department/CN=$DOMAIN_NAME"

# update permission
chmod 777 /var/www/html

# update domain name in nginx.conf
sed -i "s/DOMAIN_NAME_HERE/$DOMAIN_NAME/" /etc/nginx/sites-enabled/default

echo "start nginx in the foreground ..."
# -g "deamon off;" to run in the foreground instead of detaching into the background
# keeps the container running ...
nginx -g "daemon off;"
