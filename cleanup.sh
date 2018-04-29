#!/usr/bin/env bash

echo "Removing docker container"
docker stop idgen_container
docker rm idgen_container
docker volume prune
