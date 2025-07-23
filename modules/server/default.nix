{ lib, ... }: {
  imports = [
    ./jellyfin.nix
    ./manga.nix
  ];
  
  options.greenery.server.enable = lib.mkEnableOption "enable server modules";

}
