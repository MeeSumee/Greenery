# Beryl Hardware Configuration
{
  config,
  lib,
  pkgs,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    # Potential fix for AMD Rembrandt Hardware Acceleration Crash? I'll find out soon
    kernelParams = ["idle=nowwait" "iommu=pt"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e601b8ce-ce2f-423f-9dd8-dc2ea8548019";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5797-C73C";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [];

  # Enable Thunderbolt Service for USB4 support
  services.hardware.bolt.enable = true;

  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
