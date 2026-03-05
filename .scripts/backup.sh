#!/bin/bash
# Backup nymph-stack data daily
# 0 6 * * * /srv/.scripts/backup.sh >/dev/null 2>&1

# Exit on error
set -e

# Backup nymph-stack data using rustic
docker exec nymph-rustic rustic backup

# Notify the user that the backup is complete
STATUS="Rustic backup completed" \
  /srv/.scripts/notify.sh
