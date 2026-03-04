# Quartz PCI-Passthrough + Multi-Drive Support
{ config, lib, pkgs, ... }:

{

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];

  # Blacklist kvm_intel to fix virtualbox
  boot.blacklistedKernelModules = [
    "kvm_intel"
  ];

  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  
  # NixOS
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/78e79db3-4a27-47b9-ba00-a976c011fe2f";
    fsType = "ext4";
  };
  
  # Amethyst
  fileSystems."/run/media/sumee/amethyst" = {
    device = "/dev/disk/by-uuid/22496045-6215-4194-9cfb-f364aa3b0472";
    fsType = "ext4";
  };
  
  # Ametrine
  fileSystems."/run/media/sumee/ametrine" = {
    device = "/dev/disk/by-uuid/23f31baa-5f4a-427e-89f3-9599306925aa";
    fsType = "ext4";
  };
  
  # Boot
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/56C9-B0AA";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
