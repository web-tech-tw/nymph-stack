#!/bin/bash

set -e

if [ "$NYMPH_SCRIPT_NAME" != "stack-up" ]; then
    echo "Not stack-up, skip..."
    exit 0
fi

envsubst \
    <"config.yaml.tmpl" \
    >"config.yaml"

chown root:root "config.yaml"
chmod 0644 "config.yaml"

chown -R 3000:3000 "data/"
chmod -R 0755 "data/"
