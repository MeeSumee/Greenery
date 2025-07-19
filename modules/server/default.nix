{ lib, ... }: {
  imports = [
    ./kavita.nix
    ./jellyfin.nix
  ];
  
  options.greenery.server.enable = lib.mkEnableOption "enable server modules";

}
