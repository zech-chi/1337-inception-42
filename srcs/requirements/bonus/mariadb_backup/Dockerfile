FROM debian:bullseye

RUN apt -y update && apt install -y cron mariadb-server mariadb-backup

COPY backup.sh /backup.sh

COPY crontab /etc/cron.d/backup-cron

RUN chmod +x /backup.sh && chmod 644 /etc/cron.d/backup-cron

CMD ["cron", "-f"]
