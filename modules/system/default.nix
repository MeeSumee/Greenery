# Importer and Defaults maker
{
  lib,
  options,
  config,
  ...
}:{
  imports = [
    ./fish.nix
    ./fonts.nix
    ./input.nix  
    ./locale.nix    
    ./nix.nix
    ./sops.nix
  ];

  options.greenery.system.enable = lib.mkEnableOption "system";

  config = lib.mkIf config.greenery.system.enable {

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable Firmware Updates
    services.fwupd.enable = true;
  };
}
