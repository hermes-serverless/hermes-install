set -euo pipefail

DOCKER_COMPOSE_OPTS="-p hermes -f prod.docker-compose.yml"

docker-compose $DOCKER_COMPOSE_OPTS down