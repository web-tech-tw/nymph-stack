#!/bin/bash
# Backup nymph-stack data daily
# 0 6 * * * /srv/.scripts/backup.sh >/dev/null 2>&1

# Exit on error
set -e

# Backup nymph-stack data using rustic
docker exec nymph-rustic rustic backup

# Prune old backups to save space on Mondays
PRUNE_STATUS=""
if [ "$(date +%u)" -eq 1 ]; then
  docker exec nymph-rustic rustic forget --prune
  PRUNE_STATUS=" and pruned old backups"
fi

# Notify the user that the backup is complete
STATUS="Rustic backup completed$PRUNE_STATUS" \
  /srv/.scripts/notify.sh
