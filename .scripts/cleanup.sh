#!/bin/bash
# Cleanup unused Docker resource daily
# 0 3 * * * /srv/.scripts/cleanup.sh >/dev/null 2>&1

# Exit on error
set -e

# Clean up unused Docker resources
docker image prune -af --filter "until=2h"

# Notify the user that the cleanup is complete
STATUS="Docker cleanup completed" \
  /srv/.scripts/notify.sh
