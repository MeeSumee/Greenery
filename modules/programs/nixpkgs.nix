# Common Programs used by hosts
{
  inputs,
  config,
  pkgs,
  lib,
  users,
  ...
}:{

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
        btop-rocm                       # hardware monitor
        tree                            # enables tree view in terminal
        unzip                           # unzip cli utility
        fzf                             # Fuzzy finder
        npins                           # Npins source manager
        speedtest-cli                   # internet speedtest cli utility
      ];

      # Enables intel gpu monitoring
      security.wrappers.btop = { 
        owner = "root"; 
        group = "root"; 
        source = lib.getExe pkgs.btop-rocm;
        capabilities = "cap_perfmon+ep";
      };
    })

    # Desktop applications
    (lib.mkIf (config.greenery.programs.desktop.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [
        
        (pkgs.vesktop.override {
          withMiddleClickScroll = true;
          withSystemVencord = false;
        })                              # Better discord + Overrides

        qimgv                           # image viewer
        wineWowPackages.waylandFull     # wine
        xournalpp                       # note taking
        mpv                             # media player
        onlyoffice-desktopeditors       # office applications
        gparted                         # disk management software
        nautilus                        # file browser
        moonlight-qt                    # Remote to Windows GPU-Passthru
        rose-pine-gtk-theme             # Rose-Pine Gtk Theme
        grim                            # Screenshot tool
        slurp                           # area selection tool used for grim and wl-screenrec
        wl-clipboard                    # clipboard manager
        wl-screenrec                    # screen recorder
        brightnessctl                   # brightness ctl
        wlsunset                        # I need fucking blue light filter, my fucking eyes hurt
        ddcutil                         # Manipulating external monitors using i2c bus
        zpkgs.scripts.npins-show        # npins-show command

        # Cursor Package
        wo.nahidacursor

        # Noctalia Shell
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

        # Papirus Teal Icons
        wo.papiteal
      ];

      # Core desktop services
      security.polkit.enable = true;
      programs.xwayland.enable = true;
      services.gnome.gnome-keyring.enable = true;
      
      # Hint QT to use rosepine theme from gtk
      qt.platformTheme = "gtk2";

      # Theme gtk apps
      programs.dconf.profiles.user.databases = [{
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
      }];

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
        gimp                            # GIMP image manipulator
        kicad                           # KiCAD Electronic schematic/PCB designer
        rare                            # GUI based on legendary which is a port of Epic Games
        prismlauncher                   # minecraft 
        # davinci-resolve                 # Davinci-resolve video editor

        # Davinci derivation patched (－ˋ⩊ˊ－) (fails to build tho :woe:)
        # (pkgs.callPackage ./davinci.nix {})
      ];
    })
  ];
}
