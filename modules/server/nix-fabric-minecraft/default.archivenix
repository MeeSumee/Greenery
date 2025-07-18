{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
   # ./configuration.nix
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
  };
}
