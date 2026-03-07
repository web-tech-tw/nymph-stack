#!/bin/bash

set -e

envsubst \
    <"config.toml.tmpl" \
    >"config.toml"

envsubst \
    <"req_auth/.env.tmpl" \
    >"req_auth/.env"
