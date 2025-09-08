{
  config,
  pkgs,
  lib,
  users,
  ...
}: {

  options.greenery.desktop.niri.enable = lib.mkEnableOption "niri";

  config = lib.mkIf (config.greenery.desktop.niri.enable && config.greenery.desktop.enable) {

    # Enable Niri
    programs.niri = {
      enable = true;
    };

    # Set niri as default session
    services.displayManager.defaultSession = "niri";

    # Xwayland satellite for X11 Windowing Support
    systemd.user.services.xwayland-satellite.wantedBy = [ "graphical-session.target" ];

    # Niri Packages
    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    # Niri Hjem config
    hjem.users = lib.genAttrs users (user: {
      files = let

        # Set niri wallpaper
        niriwall = let
          from = ["*Why_is_IT_department_a_piece_of_shit*"];
          schizovivi = pkgs.fetchurl {
            name = "schizovivi";
            url = "https://img4.gelbooru.com/images/62/f3/62f3da5821dab06f98cfaf71dc304243.png";
            hash = "sha256-X6zdZVYi6iyGc1M065lNlcqMBVQ21RMX2IKOGAzkzqE=";
          };
          to = ["${schizovivi}"];
        in
          builtins.replaceStrings from to (builtins.readFile ../../dots/niri/config.kdl);

        # Set hyprlock wallpaper
        hyprvivi = let
          from = ["%%刺し身％％"];
          to = ["pidof hyprlock || hyprlock"];
        in   
          builtins.replaceStrings from to (builtins.readFile ../../dots/hyprland/hypridle.conf);

      in {
        ".config/niri/config.kdl".text = niriwall;
        ".config/hypr/hypridle.conf".text = hyprvivi;
      };
    });
  };
}

