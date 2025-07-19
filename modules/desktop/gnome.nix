{
  config,
  lib,
  pkgs,
  options,
  ...
}: {

  options.greenery.desktop.gnome.enable = lib.mkEnableOption "gnome";

  config = lib.mkIf (config.greenery.desktop.gnome.enable && config.greenery.desktop.enable) {

    environment.systemPackages = with pkgs; [
      # GNOME Stuff
      gnome-tweaks # Tweak gnome themes
      nordic # Gtk Theme
      papirus-icon-theme # Gtk Icons
      gnomeExtensions.kimpanel # Input Method Panel
      gnomeExtensions.blur-my-shell # Blurring Appearance Tool
      gnomeExtensions.user-themes # User themes
    ];

    # Exclude pre-installed gnome applications
    environment.gnome.excludePackages = with pkgs; [
      cheese
      gnome-console
      gnome-disk-utility
      gnome-system-monitor
      gnome-text-editor
      gnome-music
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-contacts
      decibels
      epiphany
      evince
      evolution
      geary
      loupe
      gnome-maps
      gnome-music
      gnome-online-accounts
      totem
      gnome-tour
      gnome-weather
      yelp
    ];

    # Enable GNOME Desktop
    services.desktopManager.gnome.enable = true;

    # GNOME Configuration, evading Home-Manager
    programs.dconf.profiles = {
      user.databases = [{
        settings = {
          
          "org/gnome/desktop/default-applications/terminal" = {
            exec = "foot";    
          };

          "org/gnome/desktop/interface" = {
            gtk-theme = "Nordic";
            icon-theme = "Papirus-Dark";
            cursor-theme = "xcursor-genshin-nahida";
            monospace-font-name = "Source Code Pro";
            color-scheme = "prefer-dark";
            clock-show-weekday = true;
          };

          "org/gnome/desktop/wm/preferences" = {
            theme = "Nordic";
          };

          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = true;
            night-light-temperature = lib.gvariant.mkUint32 3000;
            night-light-schedule-automatic = false;
            night-light-schedule-from = 8.0;
            night-light-schedule-to = 7.99;
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
            ];
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>t";
            command = "foot";
            name = "Foot Terminal"; 
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
            binding = "<Super>c";
            command = "gnome-calculator";
            name = "Calculator";
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
            binding = "<Super>i";
            command = "gnome-control-center";
            name = "Settings";
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
            binding = "<Super>e";
            command = "yazi";
            name = "Yazi";
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
              "davinci-resolve.desktop"
              "org.gnome.Nautilus.desktop"
              "foot.desktop"
              "org.kde.kate.desktop"
              "com.github.johnfactotum.Foliate.desktop"
            ];
          };
        };
      }];
    };
  };
}
