FROM    debian:bullseye

RUN apt-get -y update && apt-get install -y nginx openssl

COPY nginx.sh /nginx.sh

RUN chmod +x /nginx

# EXPOSE 443

CMD [ "/nginx.sh" ]