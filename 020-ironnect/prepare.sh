#!/bin/bash

set -e

envsubst \
    <"config.py.tmpl" \
    >"config.local.py"
