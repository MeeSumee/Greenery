#!/usr/bin/env bash
# Little symlink maker to deploy dots, created by AI hater's greatest enemy Claude Opus 5.5
# This works on any dotfile repo, just modify as you wish
# Usage: ./dots/deploy.sh [--dry-run] [--force]
#   --dry-run   Print what would happen, change nothing.
#   --force     Overwrite an existing non-symlink target instead of
#               backing it up to <target>.bak.
set -euo pipefail

DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
FORCE=0

for arg in "$@"; do
	case "$arg" in
	--dry-run) DRY_RUN=1 ;;
	--force) FORCE=1 ;;
	*)
		echo "Unknown argument: $arg" >&2
		exit 1
		;;
	esac
done

link() {
	local src="$1" dest="$2"

	if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
		echo "ok      $dest"
		return
	fi

	if [ -e "$dest" ] || [ -L "$dest" ]; then
		if [ "$FORCE" -eq 1 ]; then
			echo "replace $dest (was $( [ -L "$dest" ] && echo symlink || echo file/dir ))"
			[ "$DRY_RUN" -eq 1 ] || rm -rf "$dest"
		else
			echo "backup  $dest -> $dest.bak"
			[ "$DRY_RUN" -eq 1 ] || mv -f "$dest" "$dest.bak"
		fi
	fi

	echo "link    $dest -> $src"
	if [ "$DRY_RUN" -eq 0 ]; then
		mkdir -p "$(dirname "$dest")"
		ln -s "$src" "$dest"
	fi
}

for d in "$DOTS_DIR"/*/; do
	app="$(basename "$d")"
	link "${d%/}" "$HOME/.config/$app"
done
