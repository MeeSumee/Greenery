# Quartz PCI-Passthrough + Multi-Drive Support
{ config, lib, pkgs, ... }:

{

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];

  # Load VFIO Binding Modules
  boot.initrd.kernelModules = [ 
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"

    # Load AMD GPU after vfio
    "amdgpu"
  ];

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "vfio_pci.ids=8086:4680,8086:7a84,8086:7ad0,8086:7aa3,8086:7aa4"
    /* Reference
      I0MMU GROUP 2: Intel Alderlake iGPU GT1: 8086:4680
      IOMMU GROUP 13:
        Z690 Chipset LPC/eSPI Controller: 8086:7a84
        Intel Alderlake HD Audio Controller: 8086:7ad0
        Intel Alderlake PCH SMBus Controller: 8086:7aa3
        Intel Alderlake PCH SPI Controller: 8086:7aa4
    */
  ];

  # Blacklist all Kernel Drivers that are used by the above PCI-Passthrough Components
  boot.blacklistedKernelModules = [
    "i915"
    "xe"
    "snd_soc_avs"
    "snd_sof_pci_intel_tgl"
    "i2c_i801"
    "spi_intel_pci"
  ];

  boot.kernelModules = [ "kvm-intel" ];
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
