{ 
  config, 
  sources, 
  options, 
  users,
  lib,
  pkgs, 
  ... 
}:{
  
  imports = [
    (sources.hjem + "/modules/nixos")
  ];

  options.greenery.desktop.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf (config.greenery.desktop.hypridle.enable && config.greenery.desktop.enable) {

    # Hyprland idle daemon
    services.hypridle = {
      enable = true;
    };

    # Brightnessctl
    systemd.user.services.hypridle = {
      path = [ pkgs.brightnessctl ];
    };   
  };
}