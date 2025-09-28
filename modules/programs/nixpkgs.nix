# Common Programs used by GUI Hosts
{
  config,
  pkgs,
  lib,
  users,
  ...
}:{

  # Options maker
  options.greenery.programs = {
    core.enable = lib.mkEnableOption "enable core programs";

    server.enable = lib.mkEnableOption "enable server programs";

    daemon.enable = lib.mkEnableOption "enable daemon programs";

    desktop.enable = lib.mkEnableOption "enable desktop programs";

    engineering.enable = lib.mkEnableOption "enable engineering tools";

    heavy.enable = lib.mkEnableOption "enable heavy/demanding programs";
  };
  
  # Config selector
  config = lib.mkMerge [

    # Core programs
    (lib.mkIf (config.greenery.programs.core.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [

        git                             # git commands, highly important
        btop-rocm                       # hardware monitor
        tree                            # enables tree view in terminal
        unzip                           # unzip cli utility
        fzf                             # Fuzzy finder
        npins                           # Npins source manager
      ];

      # Enables intel gpu monitoring
      security.wrappers.btop = { 
        owner = "root"; 
        group = "root"; 
        source = lib.getExe pkgs.btop-rocm;
        capabilities = "cap_perfmon+ep";
      };
    })

    # Server programs
    (lib.mkIf (config.greenery.programs.server.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [
        screen                          # utility to split terminal sessions during ssh login
        speedtest-cli                   # internet speedtest cli utility
      ];

      # Enable non-nix executables
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        # Add any missing dynamic libraries for unpackaged programs
        # here, NOT in environment.systemPackages
      ];

      # Java
      programs.java.enable = true;
    })

    # Daemons and UI
    (lib.mkIf (config.greenery.programs.daemon.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [
        fuzzel                          # I went back to it cause walker is too bloated
        slurp                           # area selection tool used for grim and wl-screenrec
        wl-clipboard                    # clipboard manager
        wl-screenrec                    # screen recorder
        brightnessctl                   # brightness ctl
        wlsunset                        # I need fucking blue light filter, my fucking eyes hurt
        swww                            # SWWW wallpaper daemon
        ddcutil                         # Manipulating external monitors using i2c bus
        khal                            # CLI Calendar dependency for banshell
        zpkgs.scripts.npins-show        # npins-show command

        # Cursor Package
        (pkgs.callPackage ../../pkgs/cursors.nix {})      
      ];
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
        libreoffice-fresh               # office applications
        gparted                         # disk management software
        prismlauncher                   # minecraft 
        gnome-calculator                # gnome calculator
        nemo                            # nemo file browser
        dracula-theme                   # Dracula Gtk Theme

        (pkgs.papirus-icon-theme.override {
          color = "violet";
        })                              # Papirus Icons with violet folders
      ];

      # Theme gtk apps
      programs.dconf.profiles.user.databases = [{
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "Dracula";
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
          themeName = "Dracula";
        in {
          ".config/gtk-4.0/assets".source = "${pkgs.dracula-theme}/share/themes/${themeName}/gtk-4.0/assets";
          ".config/gtk-4.0/gtk.css".source = "${pkgs.dracula-theme}/share/themes/${themeName}/gtk-4.0/gtk.css";
          ".config/gtk-4.0/gtk-dark.css".source = "${pkgs.dracula-theme}/share/themes/${themeName}/gtk-4.0/gtk-dark.css";
        };
      });
    })

    # Engineering and projects
    (lib.mkIf (config.greenery.programs.engineering.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [
        arduino-ide                     # microcontroller programming
      ];
    })

    # Large/Demanding applications
    (lib.mkIf (config.greenery.programs.heavy.enable && config.greenery.programs.enable) {
      
      environment.systemPackages = with pkgs; [
        gimp3                           # GIMP image manipulator
        kicad                           # KiCAD Electronic schematic/PCB designer
        rare                            # GUI based on legendary which is a port of Epic Games
        # davinci-resolve                 # Davinci-resolve video editor

        # Davinci derivation patched (－ˋ⩊ˊ－) (fails to build tho :woe:)
        # (pkgs.callPackage ./davinci.nix {})
      ];
    })        
  ];
}
