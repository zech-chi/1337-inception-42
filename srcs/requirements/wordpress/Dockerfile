FROM debian:bullseye

RUN apt -y update && apt dist-upgrade -y &&\
    apt install -y php php-fpm php-mysql mariadb-client wget

COPY wordpress.sh /wordpress.sh

RUN chmod +x /wordpress.sh

CMD [ "/wordpress.sh" ]
