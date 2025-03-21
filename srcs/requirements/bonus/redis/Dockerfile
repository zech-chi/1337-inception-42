FROM debian:bullseye

RUN apt -y update && apt install -y redis-server

CMD ["redis-server", "--protected-mode", "no"]

