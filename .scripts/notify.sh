#!/bin/bash
# notify.sh - A simple script to send notifications to configured webhook URLs

set -e

WEBHOOK_URLS_TXT="${WEBHOOK_URLS_TXT:-"/srv/.scripts/notify.txt"}"
if [ ! -f "$WEBHOOK_URLS_TXT" ]; then
    echo "Webhook URLs file \"$WEBHOOK_URLS_TXT\" does not exist. Skipping notifications."
    exit 0
fi

NOTIFY() {
    local DATE_NOW="$(date)"
    local STATUS="${STATUS:-"Task has been executed"}"
    local PAYLOAD="$(jq -n --arg content "$STATUS at \`$DATE_NOW\`." '{"content": $content}')"
    curl -sSf \
        -X POST \
        -H "Content-Type: application/json" \
        -d "$PAYLOAD" \
        "$1"
}

for WEBHOOK_URL in $(cat "$WEBHOOK_URLS_TXT"); do
    NOTIFY "$WEBHOOK_URL"
done
