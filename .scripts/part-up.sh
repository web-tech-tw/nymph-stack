#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define this script name
export NYMPH_SCRIPT_NAME="part-up"

# Check directory variables
if [ ! -n "$1" ]; then
	exit 1
fi

# Assign to directory variable
dir="$(echo "$1" | jq -r '.path')/"

# Skip certain directories
if [ "$dir" == ".scripts/" ]; then
	exit 1
fi

if [ "$dir" == "static/" ]; then
	exit 1
fi

# Navigate into the directory
cd "$dir"

# Run init.sh if needed and track its state
if [ -f "init.sh" ] && { [ ! -f ".initialized" ] || ! md5sum -c .initialized >/dev/null 2>&1; }; then
	echo "Running init.sh in $dir"
	bash init.sh
	md5sum init.sh >.initialized
fi

# Run prepare.sh, it always runs
if [ -f "prepare.sh" ]; then
	echo "Running prepare.sh in $dir"
	bash prepare.sh
fi

# Deploy using docker-compose if the file exists
if [ -f "compose.yml" ]; then
    docker-compose pull
	docker-compose up -d --remove-orphans --build
else
  echo "No compose.yml found in $dir, nothing to bring up."
fi

# Notify the user that the part is up
STATUS="Part \"$dir\" is up and running" \
  /srv/.scripts/notify.sh
