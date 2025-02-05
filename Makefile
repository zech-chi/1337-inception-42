all: up

up:
	@docker-compose -f srcs/docker-compose.yml up -d --build

start:
	@docker-compose -f srcs/docker-compose.yml start

down:
	@docker-compose -f srcs/docker-compose.yml down

stop:
	@docker-compose -f srcs/docker-compose.yml stop

status:
	@docker ps

re: down all
