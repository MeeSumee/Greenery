{
  stdenv,
  mcVersion ? "1.21.5",
  forgeVersion ? "55.0.9",
  installerHash ? "",
  libHash ? "",
  fetchurl,
  jdk17,
}:
stdenv.mkDerivation (final: {
  pname = "mcforge";
  version = "${mcVersion}-${forgeVersion}";
  src = fetchurl {
    url = "https://maven.minecraftforge.net/net/minecraftforge/forge/${mcVersion}-${forgeVersion}/forge-${mcVersion}-${forgeVersion}-installer.jar";
    hash = installerHash;
  };

  dontUnpack = true;
  dontPatch = true;

  nativeBuildInputs = [jdk17];

  buildPhase = ''
    java -jar $src --installServer
  '';

  installPhase = /*bash*/ ''
    mkdir $out
    cp -r libraries $out/libraries

    # only copy if the file exists
    if [-f "forge-${mcVersion}-${forgeVersion}-shim.jar" ]; then 
      cp forge-${mcVersion}-${forgeVersion}-shim.jar $out
    else
      cp $src $out/forge-${mcVersion}-${forgeVersion}-shim.jar
    fi
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = libHash;

  passthru = {
    shim-name = "forge-${mcVersion}-${forgeVersion}-shim.jar";
  };
})
