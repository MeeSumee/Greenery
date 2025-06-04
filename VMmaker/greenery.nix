# Greenery VM Maker

{ inputs, lib, config, pkgs, ... }:

{
  imports =
    [
      # Imports
      ../hosts/greenery/configuration.nix
    ];
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  
  virtualisation.vmVariant = {
    virtualisation = {
      graphics = false; # Enable Graphics
      diskSize = 10 * 1024; # Set Disk Size in GiB
      memorySize = 4 * 1024; # Set Memory Allocation in GiB
      cores = 2; # Set number of cores
    };
  };

  users = {
    groups = {
      greenery = {};
    };
    users.greenery = {
      enable = true;
      initialPassword = "touchgrass";
      createHome = true;
      isNormalUser = true;
      group = "greenery";
      extraGroups = ["wheel"];
    };
  };
}
