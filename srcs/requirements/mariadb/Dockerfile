FROM debian:bullseye

RUN apt -y update && apt install -y mariadb-server

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY mariadb.sh /mariadb.sh

RUN chmod +x /mariadb.sh

CMD [ "/mariadb.sh" ]
