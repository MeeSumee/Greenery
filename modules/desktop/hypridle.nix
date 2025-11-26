{ 
  config, 
  lib,
  pkgs,
  inputs,
  ... 
}:{

  imports = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  options.greenery.desktop.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf (config.greenery.desktop.hypridle.enable && config.greenery.desktop.enable) {

    # Hyprland idle daemon
    services.hypridle = {
      enable = true;
    };

    # Fix paths
    systemd.user.services.hypridle.path = lib.mkForce (lib.attrValues {
      inherit (pkgs inputs) brightnessctl systemd;
      hyprlock = config.programs.hyprlock.package;
      hyprland = config.programs.hyprland.package;
      niri = config.programs.niri.package;
      mango = config.programs.mango.package;
      noctalia-shell = config.services.noctalia-shell.package;
    });
  };
}
