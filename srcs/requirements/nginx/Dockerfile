FROM debian:bullseye

RUN apt -y update && apt install -y nginx openssl

COPY nginx.conf /etc/nginx/nginx.conf

COPY nginx.sh /nginx.sh

RUN chmod +x /nginx.sh

# EXPOSE 443

CMD [ "/nginx.sh" ]