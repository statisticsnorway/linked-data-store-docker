#!/usr/bin/env bash

if [ ! -d "gsim-raml-schema" ]; then
  echo "Cloning GSIM information model...";
  git clone https://github.com/statisticsnorway/gsim-raml-schema.git
  docker run -v $(pwd)/gsim-raml-schema:/raml-project statisticsnorway/raml-to-jsonschema
else
  echo "Pulling GSIM information model changes...";
  cd gsim-raml-schema
  LAST_COMMIT_BEFORE=$(git log -1 "--format=format:%H")
  git pull --rebase https://github.com/statisticsnorway/gsim-raml-schema
  LAST_COMMIT_AFTER=$(git log -1 "--format=format:%H")
  if [ "$LAST_COMMIT_BEFORE" != "$LAST_COMMIT_AFTER" ] || [ ! -d "jsonschemas" ] || [ -z "$(ls -A jsonschemas)" ]; then
    echo "Re-generating schema files..."
    rm -rf jsonschemas
    docker run -v $(pwd):/raml-project statisticsnorway/raml-to-jsonschema
  fi
  cd -
fi


mvn clean verify dependency:copy-dependencies &&\

docker build -t lds-server:dev -f Dockerfile-dev .
