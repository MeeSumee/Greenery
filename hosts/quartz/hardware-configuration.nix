# Modify Hardware Config to support multiple drives
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Enables AMDVLK Vulkan driver
  hardware.amdgpu.amdvlk.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/78e79db3-4a27-47b9-ba00-a976c011fe2f";
    fsType = "ext4";
  };

  fileSystems."/run/media/sumee/amethyst" = {
    device = "/dev/disk/by-uuid/22496045-6215-4194-9cfb-f364aa3b0472";
    fsType = "ext4";
  };

  fileSystems."/run/media/sumee/ametrine" = {
    device = "/dev/disk/by-uuid/23f31baa-5f4a-427e-89f3-9599306925aa";
    fsType = "ext4";
  };

  fileSystems."/run/media/sumee/citrine" = {
    device = "/dev/disk/by-uuid/65778562-a080-45d8-8290-bb5d9a017885";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/56C9-B0AA";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
