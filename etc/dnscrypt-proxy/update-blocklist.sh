#!/bin/sh
set -eu

URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
TMP="/etc/dnscrypt-proxy/blocklist.txt.new"
DEST="/etc/dnscrypt-proxy/blocklist.txt"

curl -fsSL "$URL" -o "$TMP" --connect-timeout 10 --max-time 30

# Sanity check
LINES=$(wc -l < "$TMP")
if [ "$LINES" -lt 1000 ]; then
    echo "update-blocklist: fetched list only has $LINES lines, aborting" >&2
    rm -f "$TMP"
    exit 1
fi

mv "$TMP" "$DEST"

systemctl restart dnscrypt-proxy.service || true
