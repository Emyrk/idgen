#!/usr/bin/env bash
echo "Starting docker container with factomd at $1"
docker run -itd --name idgen_container -e FACTOMDHOST=$1 idgen
docker exec -it idgen_container sh guide.sh && sh
