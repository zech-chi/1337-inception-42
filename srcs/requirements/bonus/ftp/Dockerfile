FROM debian:bullseye

RUN apt -y update  && apt install -y vsftpd

COPY vsftpd.conf /etc/vsftpd.conf

COPY ftp.sh /ftp.sh

RUN chmod +x /ftp.sh

CMD [ "/ftp.sh" ]
