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
    ./systemd.nix
    ./users.nix
  ];

  options.greenery = {
    system.enable = lib.mkEnableOption "system";
    system.autoUpgrade.enable = lib.mkEnableOption "auto-update NixOS";
  };

  config = lib.mkIf config.greenery.system.enable {
    # Bootloader
    boot.loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };

    # Sudo privilege restriction
    security.sudo.execWheelOnly = true;

    # Core firmware services
    services = {
      dbus.implementation = "broker";
      fwupd.enable = lib.mkDefault true;
    };

    # Autoupgrade nixos based on stable branch
    system.autoUpgrade = lib.mkIf (config.greenery.system.autoUpgrade.enable && config.greenery.system.enable) {
      enable = true;
      flake = "github:MeeSumee/Greenery/stable";
      flags = [
        "--print-build-logs"
      ];
      dates = "Sat 12:00 UTC";
      randomizedDelaySec = "15min";
      allowReboot = true;
      runGarbageCollection = true;
      rebootWindow = {
        lower = "05:00";
        upper = "13:00";
      };
    };
  };
}
