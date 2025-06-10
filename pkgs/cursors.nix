{stdenv, fetchFromGitHub}:
stdenv.mkDerivation {
  name = "cursors";
  src = fetchFromGitHub {
    repo = "Greenery";
    owner = "MeeSumee";
    rev = "c9047cee5aed566ea47321a0d505900e415883d8";
    hash = "sha256-rCznuxP1mm5SB7t8KGzbgmqdM5Ry+e+oQXHzRp2fjq4=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/xcursor-genshin-nahida
    cp -r ./cursors/xcursor-genshin-nahida/* $out/share/icons/xcursor-genshin-nahida
    mkdir -p $out/share/icons/Firefly
    cp -r ./cursors/Firefly/* $out/share/icons/Firefly
  '';
}
