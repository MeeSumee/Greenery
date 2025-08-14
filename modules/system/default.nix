# Importer and Defaults maker
{
  lib,
  config,
  ...
}:{
  imports = [
    ./age.nix
    ./fish.nix
    ./fonts.nix
    ./input.nix  
    ./lanzaboote.nix    
    ./locale.nix    
    ./nix.nix
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
