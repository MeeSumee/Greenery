# Beryl Hardware Configuration
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.asusnumpad.nixosModules.default
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    # Potential fix for AMD Rembrandt Hardware Acceleration Crash? I'll find out soon
    kernelParams = ["idle=nowwait" "iommu=pt"];
  };

  # Enable TPM module
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  # Systemd script to delay tpm start to eliminate 256 error spam
  # adapted from https://gist.github.com/guilhem/d372e8a257d5f67678ea33c662c48f39
  systemd.services.tpm-startup = {
    description = "Execute TPM2 Startup with Delay After Suspend";
    after = [
      "systemd-suspend.service"
      "systemd-hybrid-sleep.service"
      "systemd-hibernate.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${pkgs.tpm2-tools}/bin/tpm2_startup";
    };
    wantedBy = [
      "sleep.target"
      "multi-user.target"
    ];
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

  # Enable Fingerprint Sensor, Elan 04f3:0c6e type fingerprint
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };
  services = {
    # Enable Thunderbolt Service for USB4 support
    hardware.bolt.enable = true;

    fprintd = {
      enable = true;
      package = pkgs.fprintd-tod;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-elan;
    };

    # Enable Asus Numpad Service (wayland-1 for niri)
    asus-numberpad-driver = {
      enable = true;
      layout = "up5401ea";
      wayland = true;
      waylandDisplay = "wayland-1";
      ignoreWaylandDisplayEnv = false;
      config = {
        "activation_time" = "0.5";
      };
    };
  };

  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
