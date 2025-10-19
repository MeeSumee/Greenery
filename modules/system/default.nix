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
    ./users.nix
  ];

  options.greenery.system.enable = lib.mkEnableOption "system";

  config = lib.mkIf config.greenery.system.enable {

    # Bootloader
    boot.loader.systemd-boot.enable = lib.mkDefault true;
    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

    # Enable core firmware services
    services = {
      printing.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
      fwupd.enable = true;
    };
  };
}
