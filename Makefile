WP_VOLUME_PATH = '/home/zech-chi/data/wordpress_volume'
MARIADB_VOLUME_PATH = '/home/zech-chi/data/mariadb_volume'

all: up

up:
	@mkdir -p ${WP_VOLUME_PATH}
	@mkdir -p ${MARIADB_VOLUME_PATH}
	@docker-compose -f srcs/docker-compose.yml up --build -d

start:
	@docker-compose -f srcs/docker-compose.yml start

down:
	@docker-compose -f srcs/docker-compose.yml down

stop:
	@docker-compose -f srcs/docker-compose.yml stop

status:
	@docker ps

re: down all
