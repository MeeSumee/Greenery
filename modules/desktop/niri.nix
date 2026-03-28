{
  config,
  pkgs,
  lib,
  users,
  ...
}: {
  options.greenery.desktop.niri.enable = lib.mkEnableOption "niri";

  config = lib.mkIf (config.greenery.desktop.niri.enable && config.greenery.desktop.enable) {
    # Niri programs
    programs = {
      niri = {
        enable = true;
      };
      # Seahorse for gnome-keyring monkaging
      seahorse.enable = true;
      # Autostart niri, adapted to fish from https://github.com/niri-wm/niri/discussions/2241
      fish.loginShellInit = ''
        begin
          if test -z $DISPLAY && test -z $NIRI_LOADED && test "$(tty)" = "/dev/tty1";
            set -gx NIRI_LOADED 1
            exec ${config.programs.niri.package}/bin/niri-session
          end
        end
      '';
    };

    # Recommended for niri
    security.polkit.enable = true;

    environment = {
      # Niri Dependencies
      systemPackages = with pkgs; [
        xwayland-satellite
        jq
      ];
    };

    # Niri Hjem config
    hjem.users = lib.genAttrs users (user: {
      files = let
        # Set keybind toggle scripts
        keybinds = let
          mutescript = pkgs.writeShellScriptBin "muteScript" ''
            ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle;
            ${pkgs.brightnessctl}/bin/brightnessctl -d platform::micmute set $(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -c MUTED)
          '';

          from = ["I_HATE_DMV_LINES"];
          to = ["${mutescript}/bin/muteScript"];
        in
          builtins.replaceStrings from to (builtins.readFile ../../dots/niri/config.kdl);

        # Set noctalia wallpaper
        schizomiku = pkgs.fetchurl {
          name = "schizomiku";
          url = "https://cdn.donmai.us/original/bb/e8/bbe8f1413839cdacc56b28e05c502d5d.jpg?download=1";
          hash = "sha256-XbrujvmGo90L7EOY5i1ydc3GQi77NJ68mxVHyMMq5gg=";
        };
      in {
        ".config/niri/config.kdl".text = keybinds;
        ".config/noctalia/settings.json".source = ../../dots/noctalia/settings.json;
        "wallpapers/schizomiku.jpg".source = schizomiku;
      };
    });
  };
}
