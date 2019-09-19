#!/usr/bin/env bash

if [ "$1" == "clean" ]; then
  echo "Cleaning existing associated volumes and data"
  docker-compose down
  docker volume rm $(docker volume ls -q -f "name=linked-data-store-docker_")
else
  echo "Reusing existing volumes and data"
fi

if [ "$1" == "update-images" ]; then
  for i in neo4j:3.5 postgres:11-alpine solr adminer; do
    docker pull $i &
  done
  wait
fi

docker-compose up --remove-orphans
