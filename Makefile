WP_VOLUME_PATH = '/tmp/inception_volumes/wordpress_volume3'
MARIADB_VOLUME_PATH = '/tmp/inception_volumes/mariadb_volume3'


all: up

# -d --build // add it in start at the end
up:
	@rm -rf ${WP_VOLUME_PATH}
	@rm -rf ${MARIADB_VOLUME_PATH}
	@mkdir -p ${WP_VOLUME_PATH}
	@mkdir -p ${MARIADB_VOLUME_PATH}
	@docker-compose -f srcs/docker-compose.yml up --build 

start:
	@docker-compose -f srcs/docker-compose.yml start

down:
	@rm -rf ${WP_VOLUME_PATH}
	@rm -rf ${MARIADB_VOLUME_PATH}
	@docker-compose -f srcs/docker-compose.yml down

stop:
	@docker-compose -f srcs/docker-compose.yml stop

status:
	@docker ps

re: down-vol all

down-vol:
	@docker-compose -f srcs/docker-compose.yml down -v
