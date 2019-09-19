#!/usr/bin/env bash

for i in $(find gsim-raml-schema/examples/_main -type f); do
  ENTITY=$(echo $i | sed 's:gsim-raml-schema/examples/_main/::' | sed 's:\([^_]*\).*:\1:')
  ID=$(jq -r .id "$i")
  curl -i -X PUT http://localhost:9090/ns/${ENTITY}/${ID} --data-binary "@$i" &
done

wait
