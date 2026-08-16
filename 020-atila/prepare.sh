#!/bin/bash

set -e

if [ "$NYMPH_SCRIPT_NAME" != "stack-up" ]; then
    echo "Not stack-up, skip..."
    exit 0
fi

envsubst \
    <"config.yaml.tmpl" \
    >"config.yaml"

chown 3000:3000 "./config.yaml"
