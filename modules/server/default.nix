{ lib, ... }: {
  imports = [
    ./jellyfin.nix
    ./suwayomi.nix
  ];
  
  options.greenery.server.enable = lib.mkEnableOption "enable server modules";

}
