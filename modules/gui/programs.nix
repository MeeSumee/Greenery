# Common Programs used by GUI Hosts
{
  config,
  pkgs,
  options,
  lib,
  modulesPath,
  flakeOverlays,
  inputs,
  ...
}:{
  imports = [
    # Imports
    inputs.aagl.nixosModules.default
  ];

  # Anime Games
  nix.settings = inputs.aagl.nixConfig;
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

  # Packages
  environment.systemPackages = with pkgs; [

    # Desktop Programs
    (pkgs.vesktop.override {
      withMiddleClickScroll = true;
      withSystemVencord = true;
    }) # Better discord + Overrides
    brave # Import Browser Profiles
    kdePackages.kate # Kate text editor
    foot # foot terminal
    sbctl # Secure Boot Control
    qimgv # Image viewer
    gimp3 # Image Manipulation
    wineWowPackages.waylandFull # Wine
    xournalpp # Note taking
    vlc # Old school Media Player I use
    mpv # General Purpose Media Player
    libreoffice-fresh # MSOffice Alternative
    gparted # Disk Partitioning
    prismlauncher # Minecraft
    zoom-us # Meetings
    arduino-ide # Programming
    ngspice # Electronic Circuit Simulator
    protonvpn-gui # GUI VPN Service from Proton

    # Flake Packages
    (pkgs.callPackage ../../pkgs/cursors.nix {})
  ];
}
