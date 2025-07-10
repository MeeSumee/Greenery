{
  config,
  pkgs,
  options,
  lib,
  inputs,
  users,
  ...
}: {
  # Import modules
  imports = [
    inputs.hjem.nixosModules.default
  ];

  # Forces applications to use wayland instead of Xwayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "auto";

  # Common packages
  environment.systemPackages = with pkgs; [
    # Niri/Hyprland Stuff
    fuzzel # app manager
    wl-clipboard # clipboard manager
    cliphist # clipboard history
    wl-screenrec # screen recorder
    imv # image viewer? need to talk to rex about it
    brightnessctl # brightness ctl so my eyes don't  hurt
    inputs.quickshell.packages.${pkgs.system}.default # quickshell (still not done)
    wlsunset # I need fucking blue light filter, my fucking eyes hurt

    # GNOME Stuff
    gnome-tweaks # Nahida Cursors & Other Cool Stuff >.<
    papirus-icon-theme # Icon Theme
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

  # Exclude xterm
  services.xserver.excludePackages = with pkgs; [ xterm ];
  
  # Set default applications
  xdg.mime.defaultApplications = {
  	
  };
  
  # Enable the X11 windowing system
  services.xserver = {
  	enable = true;
  	displayManager = {
  	  setupCommands = ''
  	    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --off
  	  '';
  	};
  	videoDrivers = [ "amdgpu" ];
  };

  # Enable GNOME Desktop Manager
  services.desktopManager.gnome.enable = true;
  
  # Seahorse Password Manager (Do I need this?)
  programs.seahorse.enable = true;

  # Gnome Keyring
  services.gnome.gnome-keyring.enable = true;

  # Pokit Agent (Do I need this??)
  security.soteria.enable = true;

  # Pam Services and fixing Gnome Keyring Popups (DOES THIS EVEN WORK???)
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
    gdm.enableGnomeKeyring = true;
  };

  # Gnome Keyring Packages (I dunno why keyring keeps complaining when I open brave)
  services.dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];

  # GNOME Configuration, evading Home-Manager
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
        command = "nautilus";
        name = "Files";
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
  
  # Hjem for simple home management
  hjem.users = lib.genAttrs users (user: {
    enable = true;
    directory = config.users.users.${user}.home;
    clobberFiles = lib.mkForce true;
    files = let 
      # Set face icon for all users
      faceIcon = let
        pfp = pkgs.fetchurl {
          name = "vivianpfp.jpg";
          url = "https://cdn.donmai.us/original/b3/b2/__vivian_banshee_zenless_zone_zero_drawn_by_icetea_art__b3b237c829304f29705f1291118e468f.jpg?download=1";
          hash = "sha256-KQZHp4tOufAOI4utGo8zLpihicMTzF5dRzQPEKc4omI=";
        };
      in
        pkgs.runCommandWith {
          name = "cropped-${pfp.name}";
          derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
        } ''
          magick ${pfp} -crop 1000x1000+210+100 - > $out
        '';

    in {
      ".face.icon".source = faceIcon;
      ".config/hypr/hypridle.conf".source = ../../dots/hyprland/hypridle.conf;
      ".config/foot/foot.ini".source = ../../dots/foot/foot.ini;
      ".config/fuzzel/fuzzel.ini".source = ../../dots/fuzzel/fuzzel.ini;
      ".config/fish/config.fish".source = ../../dots/fish/config.fish;
      ".config/fish/themes/Rosé Pine.theme".source = ../../dots/fish/themes/rosepine.theme;
      ".librewolf/librewolf.overrides.cfg".source = ../../dots/librewolf/librewolf.overrides.cfg;
    };
  });
}
