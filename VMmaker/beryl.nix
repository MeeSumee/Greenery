# Beryl VM Maker
{
  config,
  pkgs,
  options,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    # Imports config and undetected drivers in your system
    ../hosts/beryl/configuration.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  
  # Provide support for AMD and Intel CPUs
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  
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
