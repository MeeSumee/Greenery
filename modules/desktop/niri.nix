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

    # Niri Dependencies
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      jq
    ];

    # Niri Hjem config
    hjem.users = lib.genAttrs users (user: {
      files = let

        # Set niri wallpaper
        niriwall = let
          from = ["*Why_is_IT_department_a_piece_of_shit*"];
          schizomiku = pkgs.fetchurl {
            name = "schizomiku";
            url = "https://cdn.donmai.us/original/bb/e8/bbe8f1413839cdacc56b28e05c502d5d.jpg?download=1";
            hash = "sha256-XbrujvmGo90L7EOY5i1ydc3GQi77NJ68mxVHyMMq5gg=";
          };
          to = ["${schizomiku}"];
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

