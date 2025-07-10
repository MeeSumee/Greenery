# Safe to modify as it's under flakes hehehehaw
{ config, lib, pkgs, options, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./battery.nix
    ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  
  # Tell xserver to use amd gpu
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  # Enable Thunderbolt Service for USB4 support
  services.hardware.bolt.enable = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e601b8ce-ce2f-423f-9dd8-dc2ea8548019";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5797-C73C";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  # Enable Fingerprint Sensor, Elan 04f3:0c6e type fingerprint
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-elan;
  };

  # Enable Asus Numpad Service
  services.asus-numberpad-driver = {
    enable = true;
    layout = "up5401ea";
    wayland = true;
    waylandDisplay = "wayland-1";
    ignoreWaylandDisplayEnv = false;
    config = {
      "activation_time" = "0.5";
    };
  };

  # Potential fix for AMD Rembrandt Hardware Acceleration Crash? I'll find out soon
  boot.kernelParams = ["idle=nowwait" "iommu=pt"];

  # Enable OpenGL with AMD Vulkan (Might help Rembrandt HardwareAccel)
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        amdvlk
      ];
    };
  };

  # Sets battery charge limit, nix file stolen from nix hardware repo
  hardware.asus.battery =
  {
    chargeUpto = 80;   # Maximum level of charge for your battery, as a percentage.
    enableChargeUptoScript = true; # Whether to add charge-upto to 80
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
