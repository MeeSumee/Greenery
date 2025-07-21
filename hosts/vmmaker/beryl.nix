# Beryl VM Maker
{
  config,
  pkgs,
  options,
  lib,
  ...
}: {
  imports = [
    # Imports config and undetected drivers in your system
    ../beryl/configuration.nix
  ];
  
  # Module overrides
  greenery = {
    hardware.amdgpu.enable = lib.mkForce false;

    networking = {
      bluetooth.enable = lib.mkForce false;
      dnscrypt.enable = lib.mkForce false;
      openssh.enable = lib.mkForce false;
      taildrive.enable = lib.mkForce false;
      tailscale.enable = lib.mkForce false;
    };

    programs = {
      engineering.enable = lib.mkForce false;
      steam.enable = lib.mkForce false;
    };
  };

  # Provide support for AMD and Intel CPUs
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  
  # Enable Spice services for copy-paste 
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-autorandr.enable = true;
  
  # VM configuration
  virtualisation.vmVariant = {
    virtualisation = {
      graphics = true; # Enable Graphics
      diskSize = 10 * 1024; # Set Disk Size in GiB
      memorySize = 6 * 1024; # Set Memory Allocation in GiB
      cores = 4; # Set number of cores
      spiceUSBRedirection.enable = true; # Spice USB correction thingy I found online
      qemu.options = [
        # This set of config works well with wayland nixos, not tested on non-nixos platforms
        "-device virtio-vga-gl"
        "-display sdl,gl=on"
        "-usb -device usb-tablet"
        "-usbdevice tablet"
        # Enable copy/paste?
        # https://www.kraxel.org/blog/2021/05/qemu-cut-paste/
        "-chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on"
        "-device virtio-serial-pci"
        "-device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0"
      ];
    };
  };
  
  users = {
    groups = {
      beryl = {};
    };
    users.beryl = {
      enable = true;
      initialPassword = "berylline";
      createHome = true;
      isNormalUser = true;
      group = "beryl";
      extraGroups = ["wheel" "video" "audio"];
    };
  };
}
