# Common Programs used by GUI Hosts
{
  config,
  pkgs,
  options,
  lib,
  sources,
  ...
}:{
  # Imports
  imports = [
    (sources.aagl + "/module")
  ];

  # Cache loader for anime games
  nix.settings.extra-substituters = ["https://ezkea.cachix.org"];
  nix.settings.extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];

  # Enable individual anime games
  programs = {
    # Gayshit Impact
    anime-game-launcher.enable = true;

    # Houkai Railgun
    honkers-railway-launcher.enable = false;

    # Goonless Gooners
    sleepy-launcher.enable = false;

    # Houkai Deadge 3
    honkers-launcher.enable = false;

    # Limited Waves
    wavey-launcher.enable = false;
  };

  # Librewolf Browser with customized settings
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
  };

  # Gaseous H2O
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; #Firewall port for steam remote play
    dedicatedServer.openFirewall = true; #Firewall port for dedicated server
    localNetworkGameTransfers.openFirewall = true; #Firewall port for local network game transfers
    gamescopeSession.enable = true;
  };

  # Java
  programs.java.enable = true;

  # Foot terminal
  programs.foot = {
    enable = true;
  };

  # Packages
  environment.systemPackages = with pkgs; [
    # GUI tools
    walker                         # Fuzzel, but more bloat :V (needs optimizing)
    wl-clipboard                   # clipboard manager
    iwmenu                         # Wifi Menu for walker
    bzmenu                         # Bluetooth Menu for walker
    wl-screenrec                   # screen recorder
    brightnessctl                  # brightness ctl
    wlsunset                       # I need fucking blue light filter, my fucking eyes hurt
    quickshell                     # QUICKSHELL. GUYS, IT'S QUICK!
    swww                           # SWWW wallpaper daemon
    ddcutil                        # Manipulating external monitors using i2c bus

    # Desktop Programs
    (pkgs.vesktop.override {
      withMiddleClickScroll = true;
      withSystemVencord = true;
    })                             # Better discord + Overrides
    brave                          # Import Browser Profiles
    vscodium                       # vscodium for gui IDE
    sbctl                          # Secure Boot Control
    qimgv                          # Image viewer
    gimp3                          # Image Manipulation
    wineWowPackages.waylandFull    # Wine
    xournalpp                      # Note taking
    vlc                            # Old school Media Player I use
    mpv                            # General Purpose Media Player
    libreoffice-fresh              # MSOffice Alternative
    gparted                        # Disk Partitioning
    prismlauncher                  # Minecraft
    zoom-us                        # Meetings
    arduino-ide                    # Programming
    ngspice                        # Electronic Circuit Simulator
    protonvpn-gui                  # GUI VPN Service from Proton

    # Cursor Package
    (pkgs.callPackage ../../pkgs/cursors.nix {})
  ];
}
