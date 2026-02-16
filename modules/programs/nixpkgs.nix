# Common Programs used by hosts
{
  config,
  pkgs,
  lib,
  users,
  ...
}: {
  # Options maker
  options.greenery.programs = {
    core.enable = lib.mkEnableOption "enable core programs";

    desktop.enable = lib.mkEnableOption "enable desktop programs";

    heavy.enable = lib.mkEnableOption "enable heavy/demanding programs";
  };

  # Config selector
  config = lib.mkMerge [
    # Core programs
    (lib.mkIf (config.greenery.programs.core.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [
        btop # hardware monitor
        tree # enables tree view in terminal
        unzip # unzip cli utility
        fzf # Fuzzy finder
        npins # Npins source manager
        speedtest-cli # internet speedtest cli utility
      ];

      # Enables intel gpu monitoring
      security.wrappers.btop = {
        owner = "root";
        group = "root";
        source = lib.getExe pkgs.btop;
        capabilities = "cap_perfmon+ep";
      };
    })

    # Desktop applications
    (lib.mkIf (config.greenery.programs.desktop.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [
        qimgv # image viewer
        wineWowPackages.waylandFull # wine
        xournalpp # note taking
        mpv # media player
        onlyoffice-desktopeditors # office applications
        gparted # disk management software
        nautilus # file browser
        gnome-calculator # calculator
        moonlight-qt # Remote to Windows GPU-Passthru
        rose-pine-gtk-theme # Rose-Pine Gtk Theme
        slurp # area selection tool used for wl-screenrec
        wl-clipboard # clipboard manager
        wl-screenrec # screen recorder
        brightnessctl # brightness ctl
        wlsunset # I need fucking blue light filter, my fucking eyes hurt
        noctalia-shell # Noctalia Shell
        wo.nahidacursor # Cursor Package
        wo.papiteal # Papirus Teal Icons
        wo.vesktop # Vesktop with overrides
      ];

      # Core desktop services
      security.polkit.enable = true;
      programs.xwayland.enable = true;
      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "foot/footclient";
      };
      services.gnome.gnome-keyring.enable = true;

      # Hint QT to use rosepine theme from gtk
      qt.platformTheme = "gtk2";

      # Theme gtk apps
      programs.dconf.profiles.user.databases = [
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

      # Correct gtk theming for apps that don't use runtime directory
      hjem.users = lib.genAttrs users (user: {
        files = let
          themeName = "rose-pine";
          themeDir = "${pkgs.rose-pine-gtk-theme}/share/themes/${themeName}/gtk-4.0";
        in {
          ".config/gtk-4.0/assets".source = "${themeDir}/assets";
          ".config/gtk-4.0/gtk.css".source = "${themeDir}/gtk.css";
          ".config/gtk-4.0/gtk-dark.css".source = "${themeDir}/gtk-dark.css";
        };
      });
    })

    # Large/Demanding applications
    (lib.mkIf (config.greenery.programs.heavy.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [
        gimp # GIMP image manipulator
        kicad-small # KiCAD Electronic schematic/PCB designer
        rare # GUI based on legendary which is a port of Epic Games
        prismlauncher # minecraft
        # davinci-resolve                 # Davinci-resolve video editor
        audacity # temp replacement
        # Davinci derivation patched (－ˋ⩊ˊ－) (fails to build tho :woe:)
        # (pkgs.callPackage ./davinci.nix {})
      ];
    })
  ];
}
