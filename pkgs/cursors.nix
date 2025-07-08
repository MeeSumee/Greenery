{stdenv, fetchFromGitHub}:
stdenv.mkDerivation {
  name = "cursors";
  src = fetchFromGitHub {
    repo = "Greenery";
    owner = "MeeSumee";
    rev = "cc9b437c88bb2bf1f1b46507f1df8964c058d215";
    hash = "sha256-iKawpcP5JzEpfdv5OiUPa38K2BkbNSfkWfR/vLEfie8=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/xcursor-genshin-nahida
    cp -r ./dots/cursors/xcursor-genshin-nahida/* $out/share/icons/xcursor-genshin-nahida
    mkdir -p $out/share/icons/Firefly
    cp -r ./dots/cursors/Firefly/* $out/share/icons/Firefly
  '';
}
