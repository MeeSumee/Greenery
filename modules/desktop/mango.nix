{
  inputs,
  lib,
  config,
  pkgs,
  users,
  ...
}: {
  imports = [
    inputs.mango.nixosModules.mango
  ];

  options.greenery.desktop.mango.enable = lib.mkEnableOption "MangoWC WM";

  config = lib.mkIf (config.greenery.desktop.mango.enable && config.greenery.desktop.enable) {
    programs.mango.enable = true;

    security.polkit.enable = true;
    programs.xwayland.enable = true;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.gnome-keyring];
      config.mango = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
      };
    };

    # Mango Hjem config
    hjem.users = lib.genAttrs users (user: {
      files = let

        startscript = pkgs.writeShellScriptBin "start-script" ''
          set +e
          echo "Xft.dpi: 140" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface text-scaling-factor 1.4 &
          ${pkgs.wlsunset}/bin/wlsunset -T 3000 -t 2999 &
          ${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia-shell &
        '';

        # Set mic mute toggle command
        xf86keybind = let
          # camerascript = pkgs.writeShellScriptBin "camScript" ''
          #   if ${pkgs.kmod}/bin/lsmod | grep -q uvcvideo; then
          #     ${pkgs.polkit}/bin/pkexec ${pkgs.kmod}/bin/modprobe -rf uvcvideo;
          #     ${pkgs.brightnessctl}/bin/brightnessctl -d asus::camera set 1
          #   else
          #     ${pkgs.polkit}/bin/pkexec ${pkgs.kmod}/bin/modprobe uvcvideo;
          #     ${pkgs.brightnessctl}/bin/brightnessctl -d asus::camera set 0
          #   fi
          # '';

          mutescript = pkgs.writeShellScriptBin "muteScript" ''
            ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle;
            ${pkgs.brightnessctl}/bin/brightnessctl -d platform::micmute set $(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -c MUTED)
          '';

          # from = ["I_HATE_DMV_LINES" "NICHIFALEMA?"];
          # to = ["${mutescript}/bin/muteScript" "${camerascript}/bin/camScript"];
          from = ["STOPMAKINGYOURCONFIGAHELLSCAPE"];
          to = ["${mutescript}/bin/muteScript"];
        in
          builtins.replaceStrings from to (builtins.readFile ../../dots/mango/config.conf);

      in {
        ".config/mango/config.conf".text = xf86keybind;
        ".config/mango/autostart.sh".source = "${startscript}/bin/start-script";
      };
    });
  };
}
