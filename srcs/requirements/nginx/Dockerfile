FROM debian:bullseye

RUN apt -y update && apt install -y nginx openssl

COPY nginx.conf /etc/nginx/sites-enabled/default

COPY nginx.sh /nginx.sh

RUN chmod +x /nginx.sh

CMD [ "/nginx.sh" ]
