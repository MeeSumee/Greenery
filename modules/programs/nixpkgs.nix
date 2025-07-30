# Common Programs used by GUI Hosts
{
  config,
  pkgs,
  options,
  lib,
  sources,
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
        npins                           # sources manager and replaces my flakes

        # npins-show command script
        (pkgs.callPackage (sources.zaphkiel + "/pkgs/scripts/npins-show.nix") {
          writeAwk = pkgs.callPackage (sources.zaphkiel + "/pkgs/scripts/writeAwkScript.nix") {};
        })
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
        quickshell                      # QUICKSHELL. GUYS, IT'S QUICK!
        swww                            # SWWW wallpaper daemon
        ddcutil                         # Manipulating external monitors using i2c bus
        khal                            # CLI Calendar dependency for banshell

        # Cursor Package
        (pkgs.callPackage ../../pkgs/cursors.nix {})      
      ];
    })

    # Desktop applications
    (lib.mkIf (config.greenery.programs.desktop.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [
        
        (pkgs.vesktop.override {
          withMiddleClickScroll = true;
          withSystemVencord = true;
        })                              # Better discord + Overrides

        vscodium                        # GUI editing + too shit at nvim
        qimgv                           # image viewer
        wineWowPackages.waylandFull     # wine
        xournalpp                       # note taking
        mpv                             # media player
        libreoffice-fresh               # office applications
        gparted                         # disk management software
        prismlauncher                   # minecraft 
        zoom-us                         # meetings
        protonvpn-gui                   # proton vpn
        gnome-calculator                # gnome calculator
        nautilus                        # gnome file browser
        komikku                         # manga reading app
        nordic                          # Gtk Theme
        papirus-icon-theme              # Gtk Icons
      ];

      # Theme gtk apps
      programs.dconf.profiles.user.databases = [{
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "Nordic";
            icon-theme = "Papirus-Dark";
            cursor-theme = "xcursor-genshin-nahida";
            monospace-font-name = "Source Code Pro";
            color-scheme = "prefer-dark";
            clock-show-weekday = true;
          };
        };
      }];
      
      # Kurukuru bar and friends
      nixpkgs.overlays = [
        (final: prev: {
          # essentially creates a new package called kurukuru bar
          kurukurubar = final.callPackage (sources.zaphkiel + "/pkgs/kurukurubar.nix") {
            librebarcode = final.callPackage (sources.zaphkiel + "/pkgs/librebarcode.nix") {};
            gpurecording = final.callPackage (sources.zaphkiel + "/pkgs/scripts/gpurecording.nix") {};
            quickshell = final.callPackage (sources.quickshell) {};
          };
        })
      ];
    })

    # Engineering and projects
    (lib.mkIf (config.greenery.programs.engineering.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [
        audacity                        # audio editor
        arduino-ide                     # microcontroller programming
        octave                          # Scientific Programming Language
      ];
    })

    # Large/Demanding applications
    (lib.mkIf (config.greenery.programs.heavy.enable && config.greenery.programs.enable) {
      environment.systemPackages = with pkgs; [
        gimp3                           # GIMP image manipulator
        kicad                           # KiCAD Electronic schematic/PCB designer
        rare                            # GUI based on legendary which is a port of Epic Games
        davinci-resolve                 # Davinci Resolve Free Video Editor
      ];
    })        
  ];
}
