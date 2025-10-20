{stdenv, fetchFromGitHub}:
stdenv.mkDerivation {
  name = "cursors";
  src = fetchFromGitHub {
    repo = "Greenery";
    owner = "MeeSumee";
    rev = "78440f3ba04bf208abed1d252e7b27fa10c0d8ec";
    hash = "sha256-Cfcin/zhI+iyN0Qi/Q3VfOAKNgZvE8bWpd+RGUP/KH0=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/xcursor-genshin-nahida
    cp -r ./dots/cursors/xcursor-genshin-nahida/* $out/share/icons/xcursor-genshin-nahida
  '';
}
