#!/bin/bash

set -e

if [ "$NYMPH_SCRIPT_NAME" != "stack-up" ]; then
    echo "Not stack-up, skip..."
    exit 0
fi

envsubst \
    <"mcp.toml.tmpl" \
    >"mcp.toml"

mkdir -p "received/"
chown 3000:3000 "received/"
chmod 0755 "received/"

chown root:root "mcp.toml"
chmod 0644 "mcp.toml"

docker-compose restart
