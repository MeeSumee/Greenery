{stdenv, fetchFromGitHub, pkgs}:
let
  /*
  101 - Standard
  102 - Standard (White)
  103 - Standard (Classic)
  107 - Standard (Left-Handed)
  301 - Genshin
  302 - Genshin (Elements)
  307 - Genshin (Left-Handed)
  401 - Genshin Nahida
  407 - Genshin Nahida (Left-Handed)
  501 - BTR Ahoge
  502 - BTR Ahoge (Nijika)
  503 - BTR Ahoge (Mix)
  507 - BTR Ahoge (Left-Handed)
  601 - Genshin Furina
  607 - Genshin Furina (Left-Handed)
  701 - Silent Witch
  702 - Silent Witch (Alt)
  707 - Silent Witch (Left-Handed)
  */
  theme = "401";

  cursors = {
    nahida = [
      " 01 Pointer"                   # default
      "STMC Genshin 02 Help"          # help
      "${prefix} 03 Blinking Pointer" # progress
      "${prefix} 04 Spinner"          # wait
      "${prefix} 05 Cross"            # crosshair
      "${prefix} 06 Beam"             # text
      "${prefix} 07 Pen (Mirrored)"   # Mirrored Pen
      "${prefix} 07 Pen"              # Pen
      "STMC Common 08 Not Allowed"    # not allowed
      "${prefix} 09 NS"               # NS Resize
      "${prefix} 10 EW"               # EW Resize
      "${prefix} 11 NWSE"             # NWSE Resize
      "${prefix} 12 NESW"             # NESW Resize
      "${prefix} 13 Hand"             # Grab
      "${prefix} 13 Hand"             # Grabbing
      "${prefix} 13 Hand"             # Move
      "${prefix} 14 Mirrored Pointer" # Right Pointer
      "${prefix} 15 Finger"           # Pointer
    ];
  };

  indexName = {
    Standard = ''
      Standard
      标准
      標準
      標準
    '';
    Standard_White = ''
      Standard White
      标准 白色
      標準 白色
      標準 白
    '';
    Standard_Classic = ''
      Standard Classic
      标准 经典
      標準 經典
      標準 クラシック
    '';
    Standard_Left = ''
      Standard Left-Handed
      标准 左手
      標準 左手
      標準 左手
    '';
    Genshin = ''
      Genshin Impact
      原神
      原神
      原神
    '';
    Genshin_Elements = ''
      Genshin Impact Elements
      原神 元素
      原神 元素
      原神 要素
    '';
    Genshin_Left = ''
      Genshin Impact Left-Handed
      原神 左手
      原神 左手
      原神 左手
    '';
    Nahida = ''
      Genshin Impact Nahida
      原神 纳西妲
      原神 納西妲
      原神 ナヒーダ
    '';
    Nahida_Left = ''
      Genshin Impact Nahida Left-Handed
      原神 纳西妲 左手
      原神 納西妲 左手
      原神 ナヒーダ 左手
    '';
    BTR = ''
      Bocchi the Rock!
      孤独摇滚！
      孤獨搖滾！
      ぼっち・ざ・ろっく！
    '';
    BTR_Nijika = ''
      Bocchi the Rock! Nijika
      孤独摇滚！ 虹夏
      孤獨搖滾！ 虹夏
      ぼっち・ざ・ろっく！ 虹夏
    '';
    BTR_Mix = ''
      Bocchi the Rock! Mix
      孤独摇滚！- 波奇 混
      孤獨搖滾！- 波奇 混
      ぼっち・ざ・ろっく！混
    '';
    BTR_Left = ''
      Bocchi the Rock! Left-Handed
      孤独摇滚！ 左手
      孤獨搖滾！ 左手
      ぼっち・ざ・ろっく！ 左手
    '';
    Furina = ''
      Genshin Impact Furina
      原神 芙宁娜
      原神 芙寧娜
      原神 フリーナ
    '';
    Furina_Left = ''
      Genshin Impact Furina Left-Handed
      原神 芙宁娜 左手
      原神 芙寧娜 左手
      原神 フリーナ 左手
    '';
    Witch = ''
      Silent Witch
      沉默魔女
      沉默魔女
      サイレント・ウィッチ
    '';
    Witch_Alt = ''
      Silent Witch Alternate
      沉默魔女 备用
      沉默魔女 備用
      サイレント・ウィッチ 代替
    '';
    Witch_Left = ''
      Silent Witch Left-Handed
      沉默魔女 左手
      沉默魔女 左手
      サイレント・ウィッチ 左手
    '';
  };

in stdenv.mkDerivation {
  name = "Sam-Toki Cursors";
  src = fetchFromGitHub {
    repo = "Sam-Toki-Mouse-Cursors";
    owner = "SamToki";
    rev = "b128365de9a2757e963422f3bb5ec911c269a02a";
    hash = "";
  };

  installPhase = ''
    mkdir -p $out/share/icons/xcursor-genshin-nahida
    cp -r ./dots/cursors/xcursor-genshin-nahida/* $out/share/icons/xcursor-genshin-nahida
  '';
}
