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
    systemd.user.services.xwayland-satellite.wantedBy = ["graphical-session.target"];

    # Niri Dependencies
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      jq
    ];

    # Niri Hjem config
    hjem.users = lib.genAttrs users (user: {
      files = let
        # Set keybind toggle scripts
        keybinds = let
          camerascript = pkgs.writeShellScriptBin "camScript" ''
            if ${pkgs.kmod}/bin/lsmod | grep -q uvcvideo; then
              ${pkgs.polkit}/bin/pkexec ${pkgs.kmod}/bin/modprobe -rf uvcvideo;
              ${pkgs.brightnessctl}/bin/brightnessctl -d asus::camera set 1
            else
              ${pkgs.polkit}/bin/pkexec ${pkgs.kmod}/bin/modprobe uvcvideo;
              ${pkgs.brightnessctl}/bin/brightnessctl -d asus::camera set 0
            fi
          '';

          mutescript = pkgs.writeShellScriptBin "muteScript" ''
            ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle;
            ${pkgs.brightnessctl}/bin/brightnessctl -d platform::micmute set $(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -c MUTED)
          '';

          from = ["I_HATE_DMV_LINES" "NICHIFALEMA?"];
          to = ["${mutescript}/bin/muteScript" "${camerascript}/bin/camScript"];
        in
          builtins.replaceStrings from to (builtins.readFile ../../dots/niri/config.kdl);

        # Set hypridle command
        quickidle = let
          from = [
            "%%刺し身％％"
            "%%WOEMYASS**"
            "%%HAEINCI&&"
          ];
          # qs keeps crashing during Wlr session lock, so hyprlock for now
          to = [
            # "noctalia-shell ipc call lockScreen lock"
            "pidof hyprlock || hyprlock"
            "niri msg action power-on-monitors"
            "niri msg action power-off-monitors"
          ];
        in
          builtins.replaceStrings from to (builtins.readFile ../../dots/hyprland/hypridle.conf);

        # Set noctalia wallpaper
        schizomiku = pkgs.fetchurl {
          name = "schizomiku";
          url = "https://cdn.donmai.us/original/bb/e8/bbe8f1413839cdacc56b28e05c502d5d.jpg?download=1";
          hash = "sha256-XbrujvmGo90L7EOY5i1ydc3GQi77NJ68mxVHyMMq5gg=";
        };
      in {
        ".config/niri/config.kdl".text = keybinds;
        ".config/hypr/hypridle.conf".text = quickidle;
        ".config/noctalia/colors.json".source = "${pkgs.noctalia-shell}/share/noctalia-shell/Assets/ColorScheme/Rosepine/Rosepine.json";
        ".config/noctalia/settings.json".source = ../../dots/noctalia/settings.json;
        "wallpapers/schizomiku.jpg".source = schizomiku;
      };
    });
  };
}
