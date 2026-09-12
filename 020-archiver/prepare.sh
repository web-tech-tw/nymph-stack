#!/bin/bash

set -e

if [ "$NYMPH_SCRIPT_NAME" != "stack-up" ]; then
    echo "Not stack-up, skip..."
    exit 0
fi

mkdir -p "received/"
chown 3000:3000 "received/"
chmod 0755 "received/"

chown root:root "mapping.toml"
chmod 0644 "mapping.toml"

docker-compose restart
