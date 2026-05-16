{
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot = {
    loader = {
      efi.canTouchEfiVariables = lib.mkForce false;
      systemd-boot.enable = lib.mkForce false;
      grub = {
        enable = true;
        configurationLimit = 5;
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
      };
    };
    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "xen_blkfront" "vmw_pvscsi"];
      kernelModules = [];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/52ae6ee1-dbc1-416c-ab22-a80fc1fdf8d1";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/1FC0-9FA9";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };
}
