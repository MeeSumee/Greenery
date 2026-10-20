#!/bin/sh
# Fetches StevenBlack's unified hosts blocklist for dnscrypt-proxy.
# dnscrypt-proxy's blocked_names_file reads the file as-is, so the
# hosts-file "0.0.0.0 domain" lines are dropped in unmodified -- no
# reformatting needed. Replaces the npins-pinned blocklist source in the
# old modules/networking/dnscrypt.nix with a live weekly fetch (see
# update-blocklist.service/.timer).
set -eu

URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
TMP="/etc/dnscrypt-proxy/blocklist.txt.new"
DEST="/etc/dnscrypt-proxy/blocklist.txt"

curl -fsSL "$URL" -o "$TMP"

# Sanity check: don't clobber a working blocklist with a truncated/empty
# fetch (e.g. a transient GitHub outage returning an error page).
LINES=$(wc -l < "$TMP")
if [ "$LINES" -lt 1000 ]; then
    echo "update-blocklist: fetched list only has $LINES lines, aborting" >&2
    rm -f "$TMP"
    exit 1
fi

mv "$TMP" "$DEST"
systemctl try-restart dnscrypt-proxy.service || true
