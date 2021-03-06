set -euo pipefail

display_info() {
  printf "Usage ./start.sh [OPT]\nOptions are:\n"
  printf "  -h: Show this message\n"
  printf "  -m: Migrate\n"
  printf "  -s: Seed\n"
  printf "  -p: Port to listen\n"
  exit 0
}

SEED=false
MIGRATE=false
PORT=9090
while getopts "mshp:" OPT; do
  case "$OPT" in
    "m") MIGRATE=true;;
    "s") SEED=true;;
    "p") PORT=$OPTARG;;
    "h") display_info;;
    "?") display_info;;
  esac 
done

docker network create hermes || true

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

echo "PORT=$PORT" > $SCRIPTPATH/.env

DOCKER_COMPOSE_OPTS="-p hermes -f prod.docker-compose.yml"

docker-compose $DOCKER_COMPOSE_OPTS pull --no-parallel
printf "\n"
docker pull hermeshub/db-migrator
printf "\n"

if [ "$MIGRATE" == "true" ] || [ "$SEED" == "true" ]; then
  docker-compose $DOCKER_COMPOSE_OPTS up -d function-registry-db 

  if [ "$MIGRATE" == "true" ]; then
    docker run --network=hermes --rm -it hermeshub/db-migrator ./scripts/migrate.sh production
  fi

  if [ "$SEED" == "true" ]; then
    docker run --network=hermes --rm -it hermeshub/db-migrator ./scripts/seed.sh production
  fi

  docker-compose $DOCKER_COMPOSE_OPTS down
fi

docker-compose $DOCKER_COMPOSE_OPTS up -d
printf "\n"

WAIT_FOR_IT_PATH="$SCRIPTPATH/wait_for_it.tmp"
HOST_PORT="localhost:$PORT"

if [ ! -f "$WAIT_FOR_IT_PATH" ]; then
  curl https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh --output $WAIT_FOR_IT_PATH
  chmod +x $WAIT_FOR_IT_PATH
fi

$WAIT_FOR_IT_PATH $HOST_PORT -s || {
  printf "Error initializing\n  "
  exit 1
}

echo "Done"