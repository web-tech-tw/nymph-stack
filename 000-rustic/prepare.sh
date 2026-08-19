#!/bin/bash

set -e

if [ "$NYMPH_SCRIPT_NAME" != "stack-up" ]; then
    echo "Not stack-up, skip..."
    exit 0
fi

envsubst \
    <"config.toml.tmpl" \
    >"config.toml"

chown root:root "config.toml"
chmod 0644 "config.toml"

envsubst \
    <"req_auth/.env.tmpl" \
    >"req_auth/.env"

chown root:root "req_auth/.env"
chmod 0644 "req_auth/.env"
