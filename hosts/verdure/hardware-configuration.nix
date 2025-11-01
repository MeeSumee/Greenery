{
  lib, 
  ... 
}:
{
  boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Set boot loader settings for RPi4B
  boot.loader = {
    efi.canTouchEfiVariables = lib.mkForce false;
    systemd-boot.enable = lib.mkForce false;
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";
}
