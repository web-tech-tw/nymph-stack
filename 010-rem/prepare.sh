#!/bin/bash

set -e

envsubst \
    <"config.yaml.tmpl" \
    >"config.yaml"

docker-compose \
    build --no-cache
