# base image is a minimal operating system environment that comes with a set of pre-installed tools, utilities, and libraries. 
# It's the starting point for building any application or service inside a Docker container.
FROM debian:bullseye

RUN apt -y update && apt install -y nginx openssl

COPY nginx.conf /etc/nginx/sites-enabled/default

COPY nginx.sh /nginx.sh

RUN chmod +x /nginx.sh

CMD [ "/nginx.sh" ]
