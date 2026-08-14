#!/bin/bash

set -e

envsubst \
    <"config.yaml.tmpl" \
    >"config.yaml"
