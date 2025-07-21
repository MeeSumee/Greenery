{ 
  config, 
  lib, 
  pkgs, 
  ...
}: {

  options.greenery.networking.bluetooth.enable = lib.mkEnableOption "bluetooth service";

  config = lib.mkIf (config.greenery.networking.bluetooth.enable && config.greenery.networking.enable) {
    
    # Enable bluetooth
    hardware.bluetooth.enable = true;
    
    # Enable blueman, bluetooth manager
    services.blueman.enable = true;

  };
}  