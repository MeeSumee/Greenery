# Greenery VM Maker

{ inputs, lib, config, pkgs, ... }:

{
  imports =
    [
      # Imports config and undetected drivers in your system
      ../hosts/greenery/configuration.nix
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Provide support for AMD and Intel CPUs
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  
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
