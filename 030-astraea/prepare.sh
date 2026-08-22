#!/bin/bash

set -e

if [ "$NYMPH_SCRIPT_NAME" != "stack-up" ]; then
    echo "Not stack-up, skip..."
    exit 0
fi

envsubst \
    <"mcp.toml.tmpl" \
    >"mcp.toml"

chown root:root "mcp.toml"
chmod 0644 "mcp.toml"

docker-compose restart
