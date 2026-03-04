{
  config,
  lib,
  pkgs,
  ...
}: {
  options.greenery.desktop.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf (config.greenery.desktop.hypridle.enable && config.greenery.desktop.enable) {
    # Hyprland idle daemon
    services.hypridle = {
      enable = true;
    };

    # Fix paths
    systemd.user.services.hypridle.path = lib.mkForce (lib.attrValues {
      inherit (pkgs) brightnessctl systemd coreutils noctalia-shell;
      hyprlock = config.programs.hyprlock.package;
      hyprland = config.programs.hyprland.package;
      niri = config.programs.niri.package;
    });
  };
}
