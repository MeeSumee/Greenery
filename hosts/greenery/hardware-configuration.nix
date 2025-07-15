# I WILL MODIFY THIS FILE XDDD
{ config, lib, pkgs, modulesPath, ... }:

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3eabe1c1-7fb6-4cef-8b40-63096d78ba82";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4ADB-C76E";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/run/media/sumee/emerald" =
    { device = "/dev/disk/by-uuid/b3c424e3-f8a5-4ca1-a5ad-5c00c0e0802b";
      fsType = "ext4";
    };

  swapDevices = [ ];
  
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
