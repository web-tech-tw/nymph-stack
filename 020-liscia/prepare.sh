#!/bin/bash

set -e

if [ "$NYMPH_SCRIPT_NAME" != "stack-up" ]; then
    echo "Not stack-up, skip..."
    exit 0
fi

chown root:root "translation.toml"
chmod 0644 "translation.toml"

docker-compose restart
