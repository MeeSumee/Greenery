# Beryl VM Maker
{
  config,
  pkgs,
  options,
  lib,
  ...
}: {
  imports = [
    # Imports
    ../hosts/beryl/configuration.nix
  ];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  
  virtualisation.vmVariant = {
    virtualisation = {
      graphics = true; # Enable Graphics
      diskSize = 10 * 1024; # Set Disk Size in GB
      memorySize = 6 * 1024; # Set Memory Allocation in GB
      cores = 4; # Set number of cores
    };
  };
  
  users = {
    groups = {
      beryl = {};
    };
    users.beryl = {
      enable = true;
      initialPassword = "berylline";
      createHome = true;
      isNormalUser = true;
      group = "beryl";
      extraGroups = ["wheel" "video" "audio"];
    };
  };
}
