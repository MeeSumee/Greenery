{
  config,
  lib,
  users,
  pkgs,
  sources,
  ...
}: {
  imports = [
    # Import files
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./niri.nix
    ./sddm.nix
    ./xserver.nix
  ];

  options.greenery.desktop = {
    enable = lib.mkEnableOption "desktop enviroment";
    autologin.enable = lib.mkEnableOption "autologin";
  };

  config = lib.mkIf config.greenery.desktop.enable {
    # Session variables for wayland usage
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    services = {
      # Automounting
      gvfs.enable = true;
      udisks2.enable = true;

      # Autologin
      getty = lib.mkIf (config.greenery.desktop.autologin.enable && config.greenery.desktop.enable) {
        autologinOnce = true;
        autologinUser = "sumee";
      };
    };

    # So I can open foot while browsing nautilus
    programs = {
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "foot";
      };

      # Theme gtk apps
      dconf.profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              gtk-theme = "rose-pine";
              icon-theme = "rose-pine";
              cursor-theme = "STMC-xcursor-nahida";
              cursor-size = lib.gvariant.mkInt32 32;
              document-font-name = "Noto Serif";
              font-name = "Noto Sans";
              monospace-font-name = "Noto Sans Mono";
              clock-show-weekday = true;
            };
          };
        }
      ];
    };

    # Hint QT to inherit adwaita from gtk
    qt = {
      enable = true;
      style = "adwaita-dark";
    };

    # Set xdg config for defaults/terminals
    xdg = {
      terminal-exec = {
        enable = true;
        settings = {
          default = [
            "foot.desktop"
          ];
        };
      };
      mime.defaultApplications = {
        "image/*" = "qimgv.desktop";
      };
    };

    # Forward themes and configs for desktop apps
    hjem.users = lib.genAttrs users (user: {
      files = let
        themeName = "rose-pine";
        themeDir = "${pkgs.rose-pine-gtk-theme}/share/themes/${themeName}";
        inherit (config.users.users.${user}) home;
        gtk-local-theme = ''
          [Settings]
          gtk-theme-name=rose-pine
          gtk-icon-theme-name=rose-pine-icons
          gtk-cursor-theme-name=STMC-xcursor-nahida
          gtk-cursor-them-size=32
        '';
      in {
        # GTK local settings
        ".config/gtk-4.0/assets".source = "${themeDir}/assets";
        ".config/gtk-4.0/gtk.css".source = "${themeDir}/gtk-4.0/gtk.css";
        ".config/gtk-4.0/settings.ini".text = gtk-local-theme;
        ".config/gtk-3.0/settings.ini".text = gtk-local-theme;
        # Bookmarks for Nautilus
        ".config/gtk-3.0/bookmarks".text = ''
          file://${home}/Documents Documents
          file://${home}/Music Music
          file://${home}/Pictures Pictures
          file://${home}/Videos Videos
          file://${home}/Downloads Downloads
          file://${home}/green green
          sftp://sumee@greenery/run/media/sumee/emerald emerald
        '';
        # MPV settings
        ".config/mpv".source = ../../dots/mpv;
        # Equibop settings (too lazy to consider only for quartz)
        ".config/equibop/settings.json".source = ../../dots/equibop/settings.json;
        ".config/equibop/settings".source = ../../dots/equibop/settings;
        ".config/equibop/themes".source = sources.rosedickord + "/dist";
      };
    });
  };
}
