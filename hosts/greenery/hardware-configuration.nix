# I WILL MODIFY THIS FILE XDDD
{
  config, 
  lib, 
  ... 
}:

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  
  # Set VFIO and IOMMU config for GPU-Passthru
  boot.initrd.kernelModules = [ 
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  boot.kernelParams = [
    "radeon.runpm=0,"
    "radeon.modeset=0,"
    "amdgpu.runpm=0,"
    "amdgpu.modeset=0,"
    "intel_iommu=on"
    "vfio_pci.ids=1002:6610,1002:aab0"
  ];

  boot.blacklistedKernelModules = [
    "amdgpu"
    "radeon"
  ];

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
    { device = "/dev/disk/by-uuid/8066d7cd-d925-42a0-be1a-9677ce7e2895";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };

  swapDevices = [ ];
  
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
