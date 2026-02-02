# Beryl Hardware Configuration
{ 
  config, 
  lib, 
  pkgs, 
  inputs, 
  ... 
}:{
  imports = [
    ./battery.nix

    # Import asus-numberpad-driver
    inputs.asusnumpad.nixosModules.default
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  
  # Enable Thunderbolt Service for USB4 support
  services.hardware.bolt.enable = true;

  # Enable TPM module
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  # Allow Sumee to have access to TPM
  users.users.sumee.extraGroups = [ "tss" ];

  fileSystems."/" = { 
    device = "/dev/disk/by-uuid/e601b8ce-ce2f-423f-9dd8-dc2ea8548019";
    fsType = "ext4";
  };

  fileSystems."/boot" = { 
    device = "/dev/disk/by-uuid/5797-C73C";
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

  # Enable Asus Numpad Service (wayland-1 for niri)
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

  # Sets battery charge limit
  hardware.asus.battery = {
    chargeUpto = 80;   # Maximum level of charge for your battery, as a percentage.
    enableChargeUptoScript = false; # Disable charge script
  };

  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
