#!/bin/bash

set -e

if [ "$NYMPH_SCRIPT_NAME" != "stack-up" ]; then
    echo "Not stack-up, skip..."
    exit 0
fi

envsubst \
    <"config.local.py.tmpl" \
    >"config.local.py"

chown root:root "config.local.py"
chmod 0644 "config.local.py"
