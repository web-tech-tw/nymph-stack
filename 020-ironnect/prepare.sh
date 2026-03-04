#!/bin/bash

set -e

envsubst \
    <"config.local.py.tmpl" \
    >"config.local.py"
