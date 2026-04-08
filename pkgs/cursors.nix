{
  lib,
  stdenv,
  fetchFromGitHub,
  win2xcur,
  shadows ? false,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  name = "xcursor-genshin-nahida";
  src = fetchFromGitHub {
    repo = "Sam-Toki-Mouse-Cursors";
    owner = "SamToki";
    rev = "a711ee74222edfb1a6a96f945221046a95342d86";
    sha256 = "sha256-bnErAQeND5hZsdrbgU7Ky0oepcAaPELANTnOJSK8gEU=";
  };

  nativeBuildInputs = [
    win2xcur
  ];

  installPhase = let
    nahida = [
      "STMC Genshin Nahida 01 Pointer.cur"
      "STMC Genshin 02 Help.cur"
      "STMC Genshin Nahida 03 Blinking Pointer.ani"
      "STMC Genshin Nahida 04 Spinner.ani"
      "STMC Genshin Nahida 05 Cross.cur"
      "STMC Genshin Nahida 06 Beam.cur"
      "STMC Genshin Nahida 07 Pen.cur"
      "STMC Common 08 Not Allowed.cur"
      "STMC Genshin Nahida 09 NS.cur"
      "STMC Genshin Nahida 10 EW.cur"
      "STMC Genshin Nahida 11 NWSE.cur"
      "STMC Genshin Nahida 12 NESW.cur"
      "STMC Common 13 Hand.cur"
      "STMC Genshin Nahida 14 Mirrored Pointer.cur"
      "STMC Common 15 Finger.cur"
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
      "dnd-move.cur"
      "up-arrow.cur"
      "pointer.cur"
    ];

    sym0 = ["arrow" "left_ptr" "size-bdiag" "size-fdiag" "size-hor" "size-ver" "top_left_arrow"];
    sym1 = ["5c6cd98b3f3ebcb1f9c7f1c204630408" "d9ce0ab605698f320427677b458ad60b" "left_ptr_help" "question_arrow" "whats_this"];
    sym2 = ["00000000000000020006000e7e9ffc3f" "08e8e1c95fe2fc01f976f1e063a24ccd" "3ecb610c1bf2410f44200f48c40d3599" "half-busy" "left_ptr_watch"];
    sym3 = ["watch"];
    sym4 = ["cross" "tcross"];
    sym5 = ["ibeam" "xterm"];
    sym6 = ["draft"];
    sym7 = ["circle" "crossed_circle"];
    sym8 = ["00008160000006810000408080010102" "n-resize" "ns-resize" "s-resize" "sb_v_double_arrow" "v_double_arrow"];
    sym9 = ["e-resize" "ew-resize" "h_double_arrow" "sb_h_double_arrow" "w-resize"];
    sym10 = ["nw-resize" "nwse-resize" "se-resize"];
    sym11 = ["ne-resize" "nesw-resize" "sw-resize"];
    sym12 = ["4498f0e0c1937ffe01fd06f973665830" "9081237383d90e509aa00f00170e968f" "closedhand" "dnd-none" "fcf21c00b30f7e3f83fe0dfd12e71cff" "move" "all-scroll" "fleur" "size_all"];
    sym13 = ["link" "alias" "640fb0e74195791501fd1ed57b41487f" "3085a0e285430894940527032f8b26df" "a2a266d0498c3104214a47bd64ab0fc8"];
    sym14 = ["9d800788f1b08800ae810202380a0822" "e29285e634086352946a0e7090d73106" "hand1" "hand2" "pointing_hand"];
    sym = [sym0 sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10 sym11 sym12 sym13 sym14];
  in ''
    mkdir -p $out/share/icons/xcursor-genshin-nahida;
    cd ./PROJECT/STMC;

    function rename() {
      ${
      lib.concatImapStringsSep " "
      (pos: input: "cp ${input} -t $out/share/icons/xcursor-genshin-nahida/${builtins.elemAt linux (pos - 1)}")
      nahida
    }
    }

    cd $out/share/icons/xcursor-genshin-nahida;

    win2xcur *.{ani,cur} -o .

    ${
      if shadows
      then "win2xcur *.{ani,cur} -o . -s"
      else ""
    };

    rm *.{ani,cur}

    function symlink() {
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 0} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 0)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 1} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 1)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 2} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 2)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 3} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 3)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 4} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 4)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 5} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 5)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 6} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 6)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 7} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 7)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 8} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 8)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 9} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 9)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 10} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 10)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 11} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 11)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 12} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 12)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 13} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 13)};
      ${lib.concatMapStringsSep " " (symlink: "ln -s $(${builtins.elemAt linux 14} | cut -f 1 -d '.') ${symlink}") (builtins.elemAt sym 14)};
    }

    function index_maker() {
      cd .. || exit
      touch index.theme
      (
        echo "[Icon Theme]"
        echo "Name=Genshin Nahida"
        echo "Name[ja]=原神 ナヒーダ"
        echo "Name[zh_CN]=原神 纳西妲"
        echo "Name[zh_TW]=原神 納西妲"
      ) >> index.theme
    }
  '';

  meta = {
    description = "Sam-Toki-Mouse-Cursors";
    homepage = "https://github.com/SamToki/Sam-Toki-Mouse-Cursors";
    changelog = "https://github.com/SamToki/Sam-Toki-Mouse-Cursors/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc-by-nc-sa-30;
    platforms = lib.platforms.all;
  };
})
