echo "create the ssl directory ..."
mkdir -p /etc/nginx/ssl

echo "create ssl certificate ..."
openssl req -x509 -nodes -newkey rsa:4096 -days 365 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=MA/ST=Khouribga/L=Khouribga/O=1337 Coding School/OU=IT Department/CN=zech-chi.42.fr"

echo "start nginx in the foreground ..."
nginx -g "daemon off;"
