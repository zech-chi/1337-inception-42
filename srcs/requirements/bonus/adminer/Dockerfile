FROM debian:bullseye

RUN apt -y update && apt install -y curl php php-mysql

COPY adminer.sh /adminer.sh

RUN chmod +x /adminer.sh

CMD [ "/adminer.sh" ]
