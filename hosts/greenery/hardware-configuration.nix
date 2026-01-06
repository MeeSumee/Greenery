# I WILL MODIFY THIS FILE XDDD
{
  config, 
  lib, 
  ... 
}:
{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];

  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3eabe1c1-7fb6-4cef-8b40-63096d78ba82";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4ADB-C76E";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  fileSystems."/run/media/sumee/emerald" = {
    device = "/dev/disk/by-uuid/8066d7cd-d925-42a0-be1a-9677ce7e2895";
    fsType = "btrfs";
    options = [ "compress=zstd" ];
  };

  swapDevices = [ ];

  # Check file consistency for taildrive
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/run/media/sumee/emerald" ];
  };
  
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
