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

        noctalia = "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia-shell";

        startscript = pkgs.writeShellScriptBin "autostart" ''
          set +e

          # Set display for screenrecording/sharing
          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

          # Set x11 scaling
          echo "Xft.dpi: 140" | ${pkgs.xorg.xrdb}/bin/xrdb -merge

          # wlsunset
          ${pkgs.wlsunset}/bin/wlsunset -T 3000 -t 2999 &

          # Noctalia Shell
          ${noctalia} &
        '';

        # Set keybind scripts
        keybind = let
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

          from = [
            "!STOP"
          ];
          to = [
            "${mutescript}/bin/muteScript"
          ];
        in
          builtins.replaceStrings from to (builtins.readFile ../../dots/mango/config.conf);

        # Set hypridle command
        quickidle = let
          from = [
            "%%刺し身％％"
            "%%WOEMYASS**"
            "%%HAEINCI&&"
          ];
          to = [
            "noctalia-shell ipc call lockScreen lock"
            "mmsg -d enable_monitor"
            "mmsg -d disable_monitor"
          ];
        in   
          builtins.replaceStrings from to (builtins.readFile ../../dots/hyprland/hypridle.conf);

      in {
        ".config/mango/config.conf".text = keybind;
        ".config/mango/autostart.sh".source = "${startscript}/bin/autostart";
        ".config/hypr/hypridle.conf".text = quickidle;
      };
    });
  };
}
