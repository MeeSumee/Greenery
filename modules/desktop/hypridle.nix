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

    # Brightnessctl + Fix hypridle not starting in uwsm hyprland env
    systemd.user.services.hypridle = {
      path = [ pkgs.brightnessctl ];
      wantedBy = [ "wayland-session@Hyprland.target" "graphical-session.target" ];
    };
    
    # Set hypridle dot file
    hjem.users = lib.genAttrs users (user: {
      enable = true;
      directory = config.users.users.${user}.home;
      clobberFiles = lib.mkForce true;
      files = {
        ".config/hypr/hypridle.conf".source = ../../dots/hyprland/hypridle.conf;
      };
    });    
  };
}