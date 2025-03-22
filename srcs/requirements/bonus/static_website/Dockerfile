FROM debian:bullseye

RUN apt -y update && apt dist-upgrade -y && apt install -y nginx

COPY index.html /var/www/html

COPY styles.css /var/www/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]
