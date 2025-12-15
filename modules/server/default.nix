{ 
  lib, 
  ... 
}: {

  imports = [
    ./anki.nix
    ./davis.nix
    ./docker.nix
    ./files.nix
    ./immich.nix
    ./jellyfin.nix
    ./memos.nix
    ./suwayomi.nix
  ];
  
  options.greenery.server.enable = lib.mkEnableOption "enable server modules";
}
