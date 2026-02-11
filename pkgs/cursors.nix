{stdenv, fetchFromGitHub, lib, pkgs,...}:
let
  /*
  List
  0 - Standard
  1 - Standard (White)
  2 - Standard (Classic)
  3 - Standard (Left-Handed)
  4 - Genshin
  5 - Genshin (Elements)
  6 - Genshin (Left-Handed)
  7 - Genshin Nahida
  8 - Genshin Nahida (Left-Handed)
  9 - BTR Ahoge
  10 - BTR Ahoge (Nijika)
  11 - BTR Ahoge (Mix)
  12 - BTR Ahoge (Left-Handed)
  13 - Genshin Furina
  14 - Genshin Furina (Left-Handed)
  15 - Silent Witch
  16 - Silent Witch (Alt)
  17 - Silent Witch (Left-Handed)
  */

  theme = Genshin-Nahida;

  Standard = ["" "" "" "" "" ""];
  Standard-White = ["" "" "" "" "" ""];
  Standard-Classic = ["" "" "" "" "" ""];
  Standard-Left-Handed = ["" "" "" "" "" ""];
  Genshin = ["" "" "" "" "" ""];
  Genshin-Elements = ["" "" "" "" "" ""];
  Genshin-Left-Handed = ["" "" "" "" "" ""];
  Genshin-Nahida = ["STMC Genshin Nahida 13 Move" "STMC Genshin Nahida 05 Cross" "STMC Genshin Nahida 10 EW" "" "" ""];
  Genshin-Nahida-Left-Handed = ["" "" "" "" "" ""];
  BTR-Ahoge = ["" "" "" "" "" ""];
  BTR-Ahoge-Nijika = ["" "" "" "" "" ""];
  BTR-Ahoge-Mix = ["" "" "" "" "" ""];
  BTR-Ahoge-Left-Handed = ["" "" "" "" "" ""];
  Genshin-Furina = ["" "" "" "" "" ""];
  Genshin-Furina-Left-Handed = ["" "" "" "" "" ""];
  Silent-Witch = ["" "" "" "" "" ""];
  Silent-Witch-Alt = ["" "" "" "" "" ""];
  Silent-Witch-Left-Handed = ["" "" "" "" "" ""];

  # Schematic taken from adwaita cursors
  xcursor = ["all-scroll" "cell" "col-resize" "context-menu" "copy" "crosshair" "default" "e-resize" "ew-resize" "grab" "grabbing" "help" "move" "n-resize" "ne-resize" "nesw-resize" "no-drop" "not-allowed" "ns-resize" "nw-resize" "nwse-resize" "pointer" "progress" "row-resize" "s-resize" "se-resize" "sw-resize" "text" "vertical-text" "w-resize" "wait" "zoom-in" "zoom-out"];

in stdenv.mkDerivation {
  name = "Sam-Toki Cursors";
  src = fetchFromGitHub {
    repo = "Sam-Toki-Mouse-Cursors";
    owner = "SamToki";
    rev = "b128365de9a2757e963422f3bb5ec911c269a02a";
    hash = "";
  };

  installPhase = ''
    ${lib.toShellVar "input" theme}
    ${lib.toShellVar "output" xcursor}
    mkdir -p $out/share/icons/xcursor-genshin-nahida
    for i in {0..32}
    do
      ${pkgs.win2xcur}/bin/win2xcur ./PROJECT/STMC/''${input[i]}.{ani,cur} -o $out/share/icons/SamToki-${theme}/''${output[i]}
    done
  '';
}
