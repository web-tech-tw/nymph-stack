#!/bin/bash

set -e

docker-compose \
    build --no-cache

if [ "$NYMPH_SCRIPT_NAME" != "stack-up" ]; then
    echo "Not stack-up, skip..."
    exit 0
fi

envsubst \
    <"config.yaml.tmpl" \
    >"config.yaml"
