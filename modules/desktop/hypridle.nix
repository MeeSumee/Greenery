{ 
  config, 
  sources, 
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
    systemd.user.services.hypridle.path = lib.mkForce (lib.attrValues {
      inherit (config.programs.hyprland) package;
      inherit (pkgs) brightnessctl kurukurubar-unstable;
    });
  };
}
