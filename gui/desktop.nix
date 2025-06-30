{
  config,
  pkgs,
  options,
  lib,
  flakeOverlays,
  inputs,
  users,
  ...
}: {
  # Import modules
  imports = [
    inputs.niri.nixosModules.niri
    inputs.hjem.nixosModules.default
  ];
  
  # Niri flake overlay
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];
  
  # Niri for laptop
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  # Hyprland for desktop
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Hyprland screen locking utility
  programs.hyprlock.enable = true;

  # Hyprland idle daemon
#  programs.hypridle.enable = true;
  
  # Set default session
  services.displayManager.defaultSession = "gnome";
  
  # Xwayland satellite for X11 Windowing Support
  systemd.user.services.xwayland-satellite.wantedBy = [ "graphical-session.target" ];
  
  # Forces applications to use wayland instead of Xwayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Desktop Dependent Packages
  environment.systemPackages = with pkgs; [
    # Niri/Hyprland Stuff
    fuzzel # I need a fucking app manager
    swww # I need a fucking background
    wl-clipboard # I need a fucking clipboard
    cliphist # I need a fucking clipboard history
    wl-screenrec # I need a fucking screen recorder
    trashy # I need to fucking stop using sudo rm
    libnotify # I need it to fucking make notifications
    imv # I need to fucking see images
    brightnessctl # I need a fucking brightness controller
    swaylock # I need to fucking lock my screen
    inputs.quickshell.packages.${pkgs.system}.default # I need fucking UI, but qml is fucking hard
    wlsunset # I need fucking blue light filter, my fucking eyes hurt

    # GNOME Stuff
    gnome-tweaks # Nahida Cursors & Other Cool Stuff >.<
    papirus-icon-theme # Icon Theme
    gnomeExtensions.kimpanel # Input Method Panel
    gnomeExtensions.blur-my-shell # Blurring Appearance Tool
    gnomeExtensions.user-themes # User themes
  ];

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Seahorse Password Manager
  programs.seahorse.enable = true;

  # GVFS Udisks2 Volume Monitor for end-4 dots
  services.udisks2.enable = true;

  # Gnome Keyring
  services.gnome.gnome-keyring.enable = true;

  # Pokit Agent
  security.soteria.enable = true;

  # Pam Services and fixing Gnome Keyring Popups
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
    gdm.enableGnomeKeyring = true;
  };

  # Gnome Keyring Packages
  services.dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];

  # GNOME & X11 Configuration, evading Home-Manager
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/desktop/interface" = {
        icon-theme = "Papirus-Dark";
        cursor-theme = "xcursor-genshin-nahida";
        monospace-font-name = "Source Code Pro";
        color-scheme = "prefer-dark";
        clock-show-weekday = true;
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-temperature = lib.gvariant.mkUint32 3000;
        night-light-schedule-automatic = false;
        night-light-schedule-from = 8.0;
        night-light-schedule-to = 7.99;
      };

      "org/gnome/desktop/background" = {
          picture-uri-dark = let
            background = pkgs.fetchurl {
              name = "vivianbg.jpeg";
              url = "https://cdn.donmai.us/original/22/3a/__vivian_banshee_zenless_zone_zero_and_1_more_drawn_by_pyogo__223ad637e74d7f5bd860e08e7ea435ad.png?download=1";
              hash = "sha256-oCx5xtlR4Kq4WGcdDHMbeMd7IiSA3RKsnh+cpD+4UY0=";
            };
          in "file://${background}";
          picture-options = "zoom";
       };
      
      "org/gnome/shell" = {
        disable-user-extensions = false;
      
        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "kimpanel@kde.org"
          "blur-my-shell@aunetx"
        ];
      
        favorite-apps = [
          "librewolf.desktop"
          "brave-browser.desktop"
          "vesktop.desktop"
          "steam.desktop"
          "com.github.xournalpp.xournalpp.desktop"
          "btop.desktop"
          "org.prismlauncher.PrismLauncher.desktop"
          "org.openshot.OpenShot.desktop"
          "org.gnome.Nautilus.desktop"
          "foot.desktop"
          "org.kde.kate.desktop"
          "com.github.johnfactotum.Foliate.desktop"
        ];
      };
    };
  }];

  # Hjem for simple home management
  hjem.users = lib.genAttrs users (user: {
    enable = true;
    directory = config.users.users.${user}.home;
    clobberFiles = lib.mkForce true;
    files = {
      ".config/niri/config.kdl".source = ../dots/niri/config.kdl;
      ".config/foot/foot.ini".source = ../dots/foot/foot.ini;
      ".config/quickshell".source = ../dots/quickshell;
      ".config/fish/config.fish".source = ../dots/fish/config.fish;
      ".config/fish/themes/Rosé Pine.theme".source = ../dots/fish/themes/rosepine.theme;
    };
  });
}
