FROM debian:bullseye

RUN apt -y update && apt dist-upgrade -y && apt install -y vsftpd

COPY ftp.sh /ftp.sh

RUN chmod +x /ftp.sh

CMD [ "/ftp.sh" ]
