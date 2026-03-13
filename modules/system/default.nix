# Importer and Defaults maker
{
  lib,
  config,
  ...
}: {
  imports = [
    ./age.nix
    ./fish.nix
    ./fonts.nix
    ./input.nix
    ./lanzaboote.nix
    ./locale.nix
    ./nix.nix
    ./users.nix
  ];

  options.greenery = {
    system.enable = lib.mkEnableOption "system";
    system.autoUpgrade.enable = lib.mkEnableOption "auto-update NixOS";
  };

  config = lib.mkIf config.greenery.system.enable {
    # Bootloader
    boot = {
      loader.systemd-boot.enable = lib.mkDefault true;
      loader.efi.canTouchEfiVariables = lib.mkDefault true;
    };

    # Nuke faster
    systemd.user.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';

    # Enable core firmware services
    services = {
      gvfs.enable = lib.mkDefault true;
      udisks2.enable = lib.mkDefault true;
      fwupd.enable = lib.mkDefault true;
    };

    system.autoUpgrade = lib.mkIf (config.greenery.system.autoUpgrade.enable && config.greenery.system.enable) {
      enable = true;
      flake = "github:MeeSumee/Greenery";
      flags = [
        "--print-build-logs"
      ];
      dates = "10:00 UTC";
      randomizedDelaySec = "45min";
      allowReboot = true;
      runGarbageCollection = true;
      rebootWindow = {
        lower = "03:00";
        upper = "12:00";
      };
    };
  };
}
