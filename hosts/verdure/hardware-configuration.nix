{lib, ...}: {
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "usbhid"];
      kernelModules = [];
    };
    kernelModules = [];
    extraModulePackages = [];

    # Set boot loader settings for RPi4B
    loader = {
      efi.canTouchEfiVariables = lib.mkForce false;
      systemd-boot.enable = lib.mkForce false;
      grub.enable = false;
      generic-extlinux-compatible = {
        enable = true;
        configurationLimit = 5;
      };
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";
}
