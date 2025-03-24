FROM debian:bullseye

RUN apt -y update && apt install -y redis-server

# --protected-mode no : allow Redis to be accessed by any IP address
# I add it because without it wordpress refuse to connect with it
CMD ["redis-server", "--protected-mode", "no"]
