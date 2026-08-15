#!/bin/bash

set -e

if [ "$NYMPH_SCRIPT_NAME" != "stack-up" ]; then
    echo "Not stack-up, skip..."
    exit 0
fi

envsubst \
    <"config.toml.tmpl" \
    >"config.toml"

envsubst \
    <"req_auth/.env.tmpl" \
    >"req_auth/.env"
