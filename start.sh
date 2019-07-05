set -euo pipefail

docker network create hermes || true

DOCKER_COMPOSE_OPTS="-p hermes -f prod.docker-compose.yml"

docker-compose $DOCKER_COMPOSE_OPTS up -d db
docker run --network=hermes --rm -it hermeshub/db-migrator ./scripts/migrate.sh production db:seed:undo:all
docker-compose $DOCKER_COMPOSE_OPTS down

docker-compose $DOCKER_COMPOSE_OPTS pull --no-parallel
printf "\n"

docker-compose $DOCKER_COMPOSE_OPTS up -d
printf "\n"

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
WAIT_FOR_IT_PATH="$SCRIPTPATH/wait_for_it.tmp"
HOST_PORT="localhost:9090"

if [ ! -f "$WAIT_FOR_IT_PATH" ]; then
  curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh --output $WAIT_FOR_IT_PATH
  chmod +x $WAIT_FOR_IT_PATH
fi

$WAIT_FOR_IT_PATH $HOST_PORT -s || {
  printf "Error initializing\n  "
  exit 1
}

echo "Done"