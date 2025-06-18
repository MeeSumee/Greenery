{
  config,
  pkgs,
  options,
  lib,
  flakeOverlays,
  inputs,
  ...
}: {
  # Import modules
  imports = [
    inputs.niri.nixosModules.niri
    inputs.hjem.nixosModules.default
  ];
  
  # Niri flake overlay
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  
  # Niri 
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  
  # Set default session
  services.displayManager.defaultSession = "gnome";
  
  # Xwayland satellite for X11 Windowing Support
  systemd.user.services.xwayland-satellite.wantedBy = [ "graphical-session.target" ];
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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
          "steam.desktop"
          "com.github.xournalpp.xournalpp.desktop"
          "btop.desktop"
          "org.prismlauncher.PrismLauncher.desktop"
          "org.openshot.OpenShot.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Console.desktop"
          "org.gnome.TextEditor.desktop"
          "com.github.johnfactotum.Foliate.desktop"
        ];
      };
    };
  }];

  # Hjem for simple home management for niri config
  hjem.users = let 
    users = ["sumeezome" "beryl"];
  in lib.genAttrs users (user: {
    inherit user;
    enable = true;
    directory = config.users.users.${user}.home;
    clobberFiles = lib.mkForce true;
    files = {
      ".config/niri/config.kdl".source = ../../hjem-template/config.kdl;
      ".config/foot/foot.ini".source = ../../hjem-template/foot.ini;
    };
  });
}
