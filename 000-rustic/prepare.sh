#!/bin/bash

set -e

envsubst \
    <"config.toml.tmpl" \
    >"config.toml"
