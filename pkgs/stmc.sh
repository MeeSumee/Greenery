#!/usr/bin/env bash
# Arch-native equivalent of pkgs/stmc.nix -- builds the STMC-xcursor-nahida
# Xcursor theme without Nix. Mirrors the nix derivation's installPhase
# step for step:
#   1. fetch Sam-Toki-Mouse-Cursors @ the pinned tag
#   2. copy each win-cursor source file to its Linux cursor-name twin
#   3. win2xcur-convert the whole set (.ani/.cur -> Xcursor)
#   4. drop the now-converted originals
#   5. symlink every alias name onto the converted base file
#   6. write index.theme
#
# Requires: curl, tar, win2xcur (`pipx install win2xcur` or AUR `win2xcur`)
set -euo pipefail

VERSION="9.06"
SHADOWS=0
PREFIX="${PREFIX:-$HOME/.local/share/icons}"

usage() {
	cat <<EOF
Usage: $(basename "$0") [--shadows] [--prefix DIR] [--version VER]

  --shadows       Pass -s to win2xcur (drop shadow layers), matching
                  stmc.nix's \`shadows ? false\` argument.
  --prefix DIR    Install under DIR/STMC-xcursor-nahida instead of
                  \$HOME/.local/share/icons/STMC-xcursor-nahida.
                  Use /usr/share/icons for a system-wide install (needs root).
  --version VER   Override the pinned Sam-Toki-Mouse-Cursors tag ($VERSION).
EOF
}

while [ $# -gt 0 ]; do
	case "$1" in
	--shadows)
		SHADOWS=1
		shift
		;;
	--prefix)
		PREFIX="$2"
		shift 2
		;;
	--version)
		VERSION="$2"
		shift 2
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		echo "Unknown argument: $1" >&2
		usage
		exit 1
		;;
	esac
done

command -v win2xcur >/dev/null 2>&1 || {
	echo "win2xcur not found on \$PATH -- install it first (pipx install win2xcur, or AUR: win2xcur)" >&2
	exit 1
}

OUT="$PREFIX/STMC-xcursor-nahida"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "Fetching Sam-Toki-Mouse-Cursors v${VERSION}..."
curl -fsSL "https://github.com/SamToki/Sam-Toki-Mouse-Cursors/archive/refs/tags/v${VERSION}.tar.gz" -o "$WORK/src.tar.gz"
tar -xzf "$WORK/src.tar.gz" -C "$WORK"
SRC="$(find "$WORK" -maxdepth 1 -type d -name 'Sam-Toki-Mouse-Cursors-*')"

mkdir -p "$OUT/cursors"

# Win-cursor source filenames, in the exact order they map onto $linux below.
# Modified a bit from actual v9.06 (carried over from stmc.nix).
nahida=(
	"STMC Genshin Nahida 01 Pointer.cur"
	"STMC Genshin 02 Help.cur"
	"STMC Genshin Nahida 03 Blinking Pointer.ani"
	"STMC Genshin Nahida 04 Spinner.ani"
	"STMC Genshin Nahida 05 Cross.cur"
	"STMC Genshin Nahida 06 Beam.cur"
	"STMC Genshin Nahida 07 Pen.cur"
	"STMC Silent Witch 08 Not Allowed.cur"
	"STMC Genshin Nahida 09 NS.cur"
	"STMC Genshin Nahida 10 EW.cur"
	"STMC Genshin Nahida 11 NWSE.cur"
	"STMC Genshin Nahida 12 NESW.cur"
	"STMC Genshin Nahida 13 Hand.cur"
	"STMC Genshin Nahida 13 Move.cur"
	"STMC Genshin Nahida 14 Mirrored Pointer.cur"
	"STMC Genshin Nahida 15 Finger.cur"
)
linux=(
	"default.cur"
	"help.cur"
	"progress.ani"
	"wait.ani"
	"crosshair.cur"
	"text.cur"
	"pencil.cur"
	"not-allowed.cur"
	"size_ver.cur"
	"size_hor.cur"
	"size_fdiag.cur"
	"size_bdiag.cur"
	"grab.cur"
	"dnd-move.cur"
	"right_ptr.cur"
	"pointer.cur"
)

pushd "$SRC/PROJECT/STMC" >/dev/null

for i in "${!nahida[@]}"; do
	cp "${nahida[$i]}" "$OUT/cursors/${linux[$i]}"
done

popd >/dev/null

win2xcur $([ "$SHADOWS" -eq 1 ] && echo "-s") "$OUT"/cursors/*.{ani,cur} -o "$OUT/cursors/"

pushd "$OUT/cursors" >/dev/null
rm -- *.ani *.cur

# Alias name -> base (extensionless, already-converted Xcursor) file,
# referenced from https://github.com/quantum5/win2xcur/blob/master/win2xcur/theme.py
# with modifications to best suit the theme.
declare -A symlinks=(
	[default]="arrow left_ptr top_left_arrow left-arrow right-arrow down-arrow sb_left_arrow sb_right_arrow sb_down_arrow top_left_corner top_right_corner bottom_left_corner bottom_right_corner top_side bottom_side left_side right_side ul_angle ur_angle ll_angle lr_angle copy dnd-copy 1081e37283d90000800003c07f3ef6bf 6407b0e94181790501fd1e167b474872 b66166c04f8c3109214a4fbd64a50fc8 zoom-in zoom-out context-menu center_ptr color-picker X_cursor x-cursor wayland-cursor pirate top_tee bottom_tee left_tee right_tee"
	[help]="5c6cd98b3f3ebcb1f9c7f1c204630408 d9ce0ab605698f320427677b458ad60b left_ptr_help question_arrow whats_this"
	[progress]="00000000000000020006000e7e9ffc3f 08e8e1c95fe2fc01f976f1e063a24ccd 3ecb610c1bf2410f44200f48c40d3599 half-busy left_ptr_watch working"
	[wait]="watch"
	[crosshair]="cross tcross cross_reverse diamond_cross cell plus"
	[text]="vertical-text ibeam xterm"
	[pencil]="pen draft draft_large draft_small"
	[not-allowed]="unavailable circle crossed_circle 03b6e0fcb3499374a867c041f52298f0 forbidden no-drop dnd-no-drop"
	[size_ver]="size_ns size-ver n-resize ns-resize s-resize sb_v_double_arrow v_double_arrow row-resize split_v double_arrow 00008160000006810000408080010102 2870a09082c103050810ffdffffe0204"
	[size_hor]="size_ew size-hor e-resize ew-resize h_double_arrow sb_h_double_arrow w-resize col-resize"
	[size_fdiag]="size_nwse size-fdiag nw-resize nwse-resize se-resize bd_double_arrow"
	[size_bdiag]="size_nesw size-bdiag ne-resize nesw-resize sw-resize fd_double_arrow"
	[grab]="4498f0e0c1937ffe01fd06f973665830 9081237383d90e509aa00f00170e968f closedhand dnd-ask dnd-none fcf21c00b30f7e3f83fe0dfd12e71cff openhand grabbing"
	[dnd-move]="move all-scroll fleur size_all"
	[right_ptr]="up-arrow up_arrow sb_up_arrow"
	[pointer]="dnd-link link alias 640fb0e74195791501fd1ed57b41487f 3085a0e285430894940527032f8b26df a2a266d0498c3104214a47bd64ab0fc8 9d800788f1b08800ae810202380a0822 e29285e634086352946a0e7090d73106 hand hand1 hand2 pointing_hand dotbox dot_box_mask draped_box icon target"
)

for base in "${!symlinks[@]}"; do
	for alias in ${symlinks[$base]}; do
		ln -sf "$base" "$alias"
	done
done

popd >/dev/null

cat <<EOF >"$OUT/index.theme"
[Icon Theme]
Name=Genshin Nahida
Name[ja]=原神 ナヒーダ
Name[zh_CN]=原神 纳西妲
Name[zh_TW]=原神 納西妲
Comment=Xcursor port of Sam-Toki Genshin Nahida
EOF

echo "Installed to $OUT"
