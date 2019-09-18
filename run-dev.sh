#!/usr/bin/env bash

if [ "$1" == "clean" ]; then
  echo "Cleaning existing associated volumes and data"
  docker-compose down
  docker volume rm $(docker volume ls -q -f "name=ldsserver")
else
  echo "Reusing existing volumes and data"
fi

ENV_FILE='docker-compose.env'
if [ -f $ENV_FILE ]; then
    eval export $(grep -v '^#' $ENV_FILE)
fi

docker-compose up --remove-orphans
