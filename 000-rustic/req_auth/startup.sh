#!/bin/sh
# startup.sh - Startup script for the req_auth service
# For Nymph-Stack Google OAuth 2.0 Authentication

set -e

docker build -t req_auth .
docker run --rm -p 9004:9004 --env-file .env req_auth
docker rmi req_auth
