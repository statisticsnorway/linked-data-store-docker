#!/usr/bin/env bash

if [ "$1" == "clean" ]; then
  echo "Cleaning existing associated volumes and data"
  docker-compose down
  docker volume rm $(docker volume ls -q -f "name=linked-data-store-docker_")
else
  echo "Reusing existing volumes and data"
fi

docker-compose up --remove-orphans
