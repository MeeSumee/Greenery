{
  lib,
  stdenv,
  fetchFromGitHub,
  win2xcur,
  shadows ? false,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "STMC-xcursor-nahida";
  version = "9.06";
  src = fetchFromGitHub {
    repo = "Sam-Toki-Mouse-Cursors";
    owner = "SamToki";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-bnErAQeND5hZsdrbgU7Ky0oepcAaPELANTnOJSK8gEU=";
  };

  nativeBuildInputs = [
    win2xcur
  ];

  installPhase = let
    # Modified a bit from actual v9.06
    nahida = [
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
    ];
    linux = [
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
    ];

    # Referenced from https://github.com/quantum5/win2xcur/blob/master/win2xcur/theme.py with modifications to best suit the theme
    default = ["arrow" "left_ptr" "top_left_arrow" "left-arrow" "right-arrow" "down-arrow" "sb_left_arrow" "sb_right_arrow" "sb_down_arrow" "top_left_corner" "top_right_corner" "bottom_left_corner" "bottom_right_corner" "top_side" "bottom_side" "left_side" "right_side" "ul_angle" "ur_angle" "ll_angle" "lr_angle" "copy" "dnd-copy" "1081e37283d90000800003c07f3ef6bf" "6407b0e94181790501fd1e167b474872" "b66166c04f8c3109214a4fbd64a50fc8" "zoom-in" "zoom-out" "context-menu" "center_ptr" "color-picker" "X_cursor" "x-cursor" "wayland-cursor" "pirate" "top_tee" "bottom_tee" "left_tee" "right_tee"];
    help = ["5c6cd98b3f3ebcb1f9c7f1c204630408" "d9ce0ab605698f320427677b458ad60b" "left_ptr_help" "question_arrow" "whats_this"];
    progress = ["00000000000000020006000e7e9ffc3f" "08e8e1c95fe2fc01f976f1e063a24ccd" "3ecb610c1bf2410f44200f48c40d3599" "half-busy" "left_ptr_watch" "working"];
    wait = ["watch"];
    crosshair = ["cross" "tcross" "cross_reverse" "diamond_cross" "cell" "plus"];
    text = ["vertical-text" "ibeam" "xterm"];
    pencil = ["pen" "draft" "draft_large" "draft_small"];
    not-allowed = ["unavailable" "circle" "crossed_circle" "03b6e0fcb3499374a867c041f52298f0" "forbidden" "no-drop" "dnd-no-drop"];
    size_ver = ["size_ns" "size-ver" "n-resize" "ns-resize" "s-resize" "sb_v_double_arrow" "v_double_arrow" "row-resize" "split_v" "double_arrow" "00008160000006810000408080010102" "2870a09082c103050810ffdffffe0204"];
    size_hor = ["size_ew" "size-hor" "e-resize" "ew-resize" "h_double_arrow" "sb_h_double_arrow" "w-resize" "col-resize"];
    size_fdiag = ["size_nwse" "size-fdiag" "nw-resize" "nwse-resize" "se-resize" "bd_double_arrow"];
    size_bdiag = ["size_nesw" "size-bdiag" "ne-resize" "nesw-resize" "sw-resize" "fd_double_arrow"];
    grab = ["4498f0e0c1937ffe01fd06f973665830" "9081237383d90e509aa00f00170e968f" "closedhand" "dnd-ask" "dnd-none" "fcf21c00b30f7e3f83fe0dfd12e71cff" "openhand" "grabbing"];
    dnd-move = ["move" "all-scroll" "fleur" "size_all"];
    right_ptr = ["up-arrow" "up_arrow" "sb_up_arrow"];
    pointer = ["dnd-link" "link" "alias" "640fb0e74195791501fd1ed57b41487f" "3085a0e285430894940527032f8b26df" "a2a266d0498c3104214a47bd64ab0fc8" "9d800788f1b08800ae810202380a0822" "e29285e634086352946a0e7090d73106" "hand" "hand1" "hand2" "pointing_hand" "dotbox" "dot_box_mask" "draped_box" "icon" "target"];
    symlinks = [default help progress wait crosshair text pencil not-allowed size_ver size_hor size_fdiag size_bdiag grab dnd-move right_ptr pointer];
  in ''
    mkdir -p $out/share/icons/STMC-xcursor-nahida/cursors
    cd ./PROJECT/STMC

    ${
      lib.concatImapStrings (pos: x: ''cp '${x}' $out/share/icons/STMC-xcursor-nahida/cursors/${builtins.elemAt linux (pos - 1)};'') nahida
    }

    win2xcur ${
      if shadows
      then "-s"
      else ""
    } $out/share/icons/STMC-xcursor-nahida/cursors/*.{ani,cur} -o $out/share/icons/STMC-xcursor-nahida/cursors/

    cd $out/share/icons/STMC-xcursor-nahida/cursors
    rm *.{ani,cur}

    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 0}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 0)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 1}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 1)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 2}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 2)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 3}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 3)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 4}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 4)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 5}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 5)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 6}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 6)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 7}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 7)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 8}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 8)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 9}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 9)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 10}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 10)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 11}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 11)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 12}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 12)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 13}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 13)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 14}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 14)}
    ${lib.concatMapStrings (symlink: "ln -s $(echo '${builtins.elemAt linux 15}' | cut -f 1 -d '.') ${symlink};") (builtins.elemAt symlinks 15)}

    cd ..
    touch index.theme
    (
      echo "[Icon Theme]"
      echo "Name=Genshin Nahida"
      echo "Name[ja]=原神 ナヒーダ"
      echo "Name[zh_CN]=原神 纳西妲"
      echo "Name[zh_TW]=原神 納西妲"
      echo "Comment=Xcursor port of Sam-Toki Genshin Nahida"
    ) >> index.theme
  '';

  meta = {
    description = "Sam-Toki-Mouse-Cursors";
    homepage = "https://github.com/SamToki/Sam-Toki-Mouse-Cursors";
    changelog = "https://github.com/SamToki/Sam-Toki-Mouse-Cursors/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc-by-nc-sa-30;
    platforms = lib.platforms.all;
  };
})
