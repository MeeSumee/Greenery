{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
#    ./hollyj.nix
#    ./backupservice.nix
  ];

  options = {
    servModule.minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft Server";
    };
  };

  config = lib.mkIf (config.servModule.minecraft.enable && config.servModule.enable) {
    users.users.minecraft.packages = [pkgs.rconc];
    nixpkgs.overlays = [inputs.nix-minecraft.overlay];

    # allows geyser proxy for hollyj
    # WARN enable offline auth imperatively in the geyser config
    # will figure out a better way to do it later
    networking.firewall = {
      allowedUDPPorts = [19132];
      allowedTCPPorts = [8080];
    };

    # mongodb :< [EasyAuth]
    services.mongodb = {
      enable = true;
      package = pkgs.mongodb-ce;
    };

    services.minecraft-servers = {
      enable = true;
      eula = true;
    };
  };
}
