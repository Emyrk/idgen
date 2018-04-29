#!/usr/bin/env bash

echo "Building Docker image"
docker build . --build-arg "FACTOMDHOST=$1" -t idgen