{
  config,
  lib,
  users,
  pkgs,
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

  options.greenery.desktop.enable = lib.mkEnableOption "desktop enviroment";

  config = lib.mkIf config.greenery.desktop.enable {
    # Session variables for wayland usage
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    # Configure autologin for graphical desktops
    services.getty = {
      autologinOnce = true;
      autologinUser = "sumee";
    };

    # Core desktop services
    security.polkit.enable = true;

    programs = {
      xwayland.enable = true;
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
              icon-theme = "Papirus-Dark";
              cursor-theme = "xcursor-genshin-nahida";
              document-font-name = "DejaVu Serif";
              font-name = "DejaVu Sans";
              monospace-font-name = "CaskaydiaMono NF";
              color-scheme = "prefer-dark";
              clock-show-weekday = true;
            };
          };
        }
      ];
    };

    services.gnome.gnome-keyring.enable = true;

    # Hint QT to use rosepine theme from gtk
    qt = {
      enable = true;
      style = "gtk2";
      platformTheme = "gtk2";
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

    # Correct gtk theming for apps that don't use runtime directory
    hjem.users = lib.genAttrs users (user: {
      files = let
        themeName = "rose-pine";
        themeDir = "${pkgs.rose-pine-gtk-theme}/share/themes/${themeName}";
      in {
        ".config/gtk-4.0/assets".source = "${themeDir}/assets";
        ".config/gtk-4.0/gtk.css".source = "${themeDir}/gtk-4.0/gtk.css";
        ".config/mpv".source = ../../dots/mpv;
      };
    });
  };
}
