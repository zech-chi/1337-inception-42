# volumes
WP_VOLUME_PATH = '/home/zech-chi/data/wordpress_volume'
MARIADB_VOLUME_PATH = '/home/zech-chi/data/mariadb_volume'

all: up

# --build: Rebuilds images if needed.
# -d: Runs containers in detached mode (background).
up:
	@mkdir -p ${WP_VOLUME_PATH}
	@mkdir -p ${MARIADB_VOLUME_PATH}
	@docker-compose -f srcs/docker-compose.yml up --build -d

# Starts stopped containers without rebuilding them.
start:
	@docker-compose -f srcs/docker-compose.yml start

# ! use sudo to run this command
# Stops and removes all containers, networks, and volumes defined in docker-compose.yml
down:
	@rm -rf ${WP_VOLUME_PATH}
	@rm -rf ${MARIADB_VOLUME_PATH}
	@docker-compose -f srcs/docker-compose.yml down

# Stops containers without removing them.
stop:
	@docker-compose -f srcs/docker-compose.yml stop

status:
	@docker ps

# ! use sudo to run this command
re: down all
