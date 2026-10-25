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
# `restart` rather than `try-restart`: on the first boot after the
# layer-packages.service reboot, dnscrypt-proxy.service isn't running yet
# at all (it's only enable'd, not started, by enable-layered-units.service
# -- deliberately, so it never starts with a stale/missing blocklist).
# `restart` starts a not-yet-running unit instead of silently no-op'ing
# like `try-restart` would. `|| true` covers the brief window before
# layer-packages.service has even run once, when the unit doesn't exist.
systemctl restart dnscrypt-proxy.service || true
