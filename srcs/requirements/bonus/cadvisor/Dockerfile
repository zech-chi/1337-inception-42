FROM debian:bullseye

RUN apt -y update && apt install -y wget

RUN wget -O /usr/bin/cadvisor https://github.com/google/cadvisor/releases/download/v0.52.1/cadvisor-v0.52.1-linux-amd64

RUN chmod +x /usr/bin/cadvisor

CMD [ "/usr/bin/cadvisor" ]
