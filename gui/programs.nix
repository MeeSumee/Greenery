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
    policies = {
      Cookies = {
        "Allow" = [
          "https://login.tailscale.com"
          "https://github.com"
        ];
        "Locked" = true;
      };
      DisableBuiltinPDFViewer = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      Preferences = {
        "browser.preferences.defaultPerformanceSettings.enabled" = false;
        "browser.startup.homepage" = "about:home";
        "browser.toolbar.bookmarks.visibility" = "newtab";
        "browser.toolbars.bookmarks.visibility" = "newtab";
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.warnOnQuit" = false;
        "browser.warnOnQuitShortcut" = false;
        "places.history.enabled" = "false";
        "cookiebanners.service.mode.privateBrowsing" = 2;
        "cookiebanners.service.mode" = 2;
        "network.cookie.lifetimePolicy" = 0;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
        "webgl.disabled" = false;
      };
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4488139/darkreader-4.9.106.xpi";
          installation_mode = "force_installed";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4493940/bitwarden_password_manager-2025.5.0.xpi";
          installation_mode = "force_installed";
        };
      };
    };
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
    kdePackages.kdenlive # Video Editing
    gimp3 # Image Manipulation
    wineWowPackages.waylandFull # Wine
    xournalpp # Note taking
    vlc # Media Player
    libreoffice-fresh # MSOffice Alternative
    gparted # Disk Partitioning
    prismlauncher # Minecraft
    zoom-us # Meetings
    arduino-ide # Programming
    ngspice # Electronic Circuit Simulator
    protonmail-desktop # Desktop Mail + Calendar
    protonvpn-gui # GUI VPN Service from Proton

    # Flake Packages
    (pkgs.callPackage ../pkgs/cursors.nix {})
  ];
}
