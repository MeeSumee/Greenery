{ 
  config, 
  lib,
  pkgs,
  inputs,
  ... 
}:{

  imports = [
    inputs.noctalia.nixosModules.default
  ];

  options.greenery.desktop.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf (config.greenery.desktop.hypridle.enable && config.greenery.desktop.enable) {

    # Hyprland idle daemon
    services.hypridle = {
      enable = true;
    };

    # Fix paths
    systemd.user.services.hypridle.path = lib.mkForce (lib.attrValues {
      inherit (pkgs) brightnessctl systemd;
      hyprlock = config.programs.hyprlock.package;
      hyprland = config.programs.hyprland.package;
      niri = config.programs.niri.package;
      mango = config.programs.mango.package;
      noctalia = config.services.noctalia-shell.package;
    });
  };
}
