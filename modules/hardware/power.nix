{
  config,
  lib,
  ...
}:{

  options.greenery.hardware.power.enable = lib.mkEnableOption "Power and Battery Options";

  config = lib.mkIf (config.greenery.hardware.power.enable && config.greenery.hardware.enable) {
    
    # Enable power profiles
    services.power-profiles-daemon.enable = true;

    # Enable upower daemon
    services.upower = {
      enable = true;
    };
  };
}
