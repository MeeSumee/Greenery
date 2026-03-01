# Common Programs used by hosts
{
  config,
  pkgs,
  lib,
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
        wineWow64Packages.wayland # wine
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
