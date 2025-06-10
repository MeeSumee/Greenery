{stdenv, fetchFromGitHub}:
stdenv.mkDerivation {
  name = "cursors";
  src = fetchFromGitHub {
    repo = "Greenery";
    owner = "MeeSumee";
    rev = "b3e311464be47f023243229e853968a5670b9952";
    hash = "sha256-7kIz3fqEeGDTVeM8nUpWxRQp9kwVpGqfx+CD+YKVT90=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/xcursor-genshin-nahida
    cp -r ./cursors/xcursor-genshin-nahida/* $out/share/icons/xcursor-genshin-nahida
    mkdir -p $out/share/icons/Firefly
    cp -r ./cursors/Firefly/* $out/share/icons/Firefly
  '';
}
