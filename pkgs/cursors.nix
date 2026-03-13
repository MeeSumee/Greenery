{
  lib,
  stdenv,
  fetchFromGitHub,
  win2xcur,
  shadows ? false,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "Sam-Toki Xcursor Genshin-Nahida";
  version = "9.0.6";
  src = fetchFromGitHub {
    repo = "Sam-Toki-Mouse-Cursors";
    owner = "SamToki";
    rev = "v${finalAttrs.version}";
    sha256 = "";
  };

  nativeBuildInputs = [
    win2xcur
  ];

  installPhase = let
    nahida = [
      "STMC Genshin Nahida 01 Pointer"
      "STMC Genshin 02 Help"
      "STMC Genshin Nahida 03 Blinking Pointer"
      "STMC Genshin Nahida 04 Spinner"
      "STMC Genshin Nahida 05 Cross"
      "STMC Genshin Nahida 06 Beam"
      "STMC Genshin Nahida 07 Pen"
      "STMC Common 08 Not Allowed"
      "STMC Genshin Nahida 09 NS"
      "STMC Genshin Nahida 10 EW"
      "STMC Genshin Nahida 11 NWSE"
      "STMC Genshin Nahida 12 NESW"
      "STMC Common 13 Hand"
      "STMC Genshin Nahida 14 Mirrored Pointer"
      "STMC Common 15 Finger"
    ];
    linux = [
      "default"
      "help"
      "progress"
      "wait"
      "crosshair"
      "text"
      "pencil"
      "not-allowed"
      "size_ver"
      "size_hor"
      "size_fdiag"
      "size_bdiag"
      "dnd-move"
      "up-arrow"
      "pointer"
    ];
  in ''
    # Symbolic Links for cursors are obtained from Breeze cursors and modified slightly
    symbolic0=("arrow" "left_ptr" "size-bdiag" "size-fdiag" "size-hor" "size-ver" "top_left_arrow")
    symbolic1=("5c6cd98b3f3ebcb1f9c7f1c204630408" "d9ce0ab605698f320427677b458ad60b" "left_ptr_help" "question_arrow" "whats_this")
    symbolic2=("00000000000000020006000e7e9ffc3f" "08e8e1c95fe2fc01f976f1e063a24ccd" "3ecb610c1bf2410f44200f48c40d3599" "half-busy" "left_ptr_watch")
    symbolic3=("watch")
    symbolic4=("cross" "tcross")
    symbolic5=("ibeam" "xterm")
    symbolic6=("draft")
    symbolic7=("circle" "crossed_circle")
    symbolic8=("00008160000006810000408080010102" "n-resize" "ns-resize" "s-resize" "sb_v_double_arrow" "v_double_arrow")
    symbolic9=("e-resize" "ew-resize" "h_double_arrow" "sb_h_double_arrow" "w-resize")
    symbolic10=("nw-resize" "nwse-resize" "se-resize")
    symbolic11=("ne-resize" "nesw-resize" "sw-resize")
    symbolic12=("4498f0e0c1937ffe01fd06f973665830" "9081237383d90e509aa00f00170e968f" "closedhand" "dnd-none" "fcf21c00b30f7e3f83fe0dfd12e71cff" "move" "all-scroll" "fleur" "size_all")
    symbolic13=("link" "alias" "640fb0e74195791501fd1ed57b41487f" "3085a0e285430894940527032f8b26df" "a2a266d0498c3104214a47bd64ab0fc8")
    symbolic14=("9d800788f1b08800ae810202380a0822" "e29285e634086352946a0e7090d73106" "hand1" "hand2" "pointing_hand")

    symbolic=("symbolic0" "symbolic1" "symbolic2" "symbolic3" "symbolic4" "symbolic5" "symbolic6" "symbolic7" "symbolic8" "symbolic9" "symbolic10" "symbolic11" "symbolic12" "symbolic13" "symbolic14")

    mkdir -p $out/share/icons/xcursor-genshin-nahida
    cd ./PROJECT/STMC
    ${lib.concatMapStringsSep " " (input: "mv ${input}.{ani,cur} $out/share/icons/xcursor-genshin-nahida/${builtins.map (output: output + "." + "") linux}") nahida}
    cd $out/share/icons/xcursor-genshin-nahida

    function convert() {
      win2xcur ./PROJECT/STMC/*.{ani,cur} -o $out/share/icons/xcursor-genshin-nahida
    }

    function convert_shadows() {
      win2xcur ./PROJECT/STMC/*.{ani,cur} -o $out/share/icons/xcursor-genshin-nahida -s
    }

    function symlinks() {
      for lincursor in "''${!linux_names[@]}"; do
        declare -n symboliclink="''${symbolic[$lincursor]}"
        for symlink in "''${!symboliclink[@]}"; do
          ln -s "''${linux_names[$lincursor]}" "''${symboliclink[$symlink]}"
        done
      done
    }

    function index_maker() {
      cd .. || exit
      touch index.theme
      (
        echo "[Icon Theme]"
        echo "Name=$Package_name"
        echo "Comment=$Package_desc"
      ) >> index.theme
    }

  '';

  meta = {
    description = "SamToki Genshin-Nahida xcursor port";
    homepage = "https://github.com/SamToki/Sam-Toki-Mouse-Cursors";
    changelog = "https://github.com/SamToki/Sam-Toki-Mouse-Cursors/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc-by-nc-sa-30;
    maintainers = with lib.maintainers; [sumee];
    platforms = lib.platforms.all;
  };
})
