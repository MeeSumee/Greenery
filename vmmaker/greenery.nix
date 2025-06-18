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
  
  # Enable Spice services for copy-paste 
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-autorandr.enable = true;
  
  virtualisation.vmVariant = {
    virtualisation = {
      graphics = false; # Enable Graphics
      diskSize = 10 * 1024; # Set Disk Size in GiB
      memorySize = 4 * 1024; # Set Memory Allocation in GiB
      cores = 2; # Set number of cores
      qemu.options = [
        # Enable copy/paste?
        # https://www.kraxel.org/blog/2021/05/qemu-cut-paste/
        "-chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on"
        "-device virtio-serial-pci"
        "-device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0"
      ];
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
