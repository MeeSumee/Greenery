{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader = {
    efi.efiSysMountPoint = "/boot/efi";
    grub = {
      efiSupport = true;
      device = "/dev/sda";
    };
  };

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ ];
  fileSystems."/" = { device = "/dev/disk/by-uuid/52ae6ee1-dbc1-416c-ab22-a80fc1fdf8d1"; fsType = "ext4"; };
  fileSystems."/boot/efi" = { device = "/dev/disk/by-uuid/1FC0-9FA9"; fsType = "vfat"; options = [ "fmask=0022" "dmask=0022" ]; };
}
