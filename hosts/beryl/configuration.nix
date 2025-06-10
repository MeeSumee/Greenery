# Start of Config
{
  config,
  pkgs,
  options,
  lib,
  modulesPath,
  flakeOverlays,
  ...
}: {
  imports = [
    # Imports.
    ./aagl.nix
  ];
  
  # Required for MATLAB
  nixpkgs.overlays = flakeOverlays;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "beryl"; # The tint of blue I like
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Set internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "ja_JP.UTF-8/UTF-8" ] ;
  };

  # Font Settings for both English and Japanese
  fonts.packages = with pkgs; [
    carlito
    dejavu_fonts
    ipafont
    kochi-substitute
    source-code-pro
    ttf_bitstream_vera
  ];
  
  # Enable fcitx for Input Method Editor (IME)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };
  
  # Add and enable mozc as input method in fcitx. Good for JP input.
  i18n.inputMethod.fcitx5 = {
    addons = [ pkgs.fcitx5-mozc ];
    
    settings.inputMethod = {
      "Groups/0" = {
        "Name" = "Default";
        "Default Layout" = "us";
        "DefaultIM" = "mozc";
      };
      "Groups/0/Items/0" = {
        "Name" = "keyboard-us";
        "Layout" = null;
      };
      "Groups/0/Items/1" = {
        "Name" = "mozc";
        "Layout" = null;
      };
    };
  };
  
  # Provides ibus for input method
  environment.variables.GLFW_IM_MODULE = "ibus";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define user accounts.
  users.users = {
    sumeezome = {
      isNormalUser = true;
      description = "Sumeezome";
      extraGroups = ["networkmanager" "wheel"];
    };
  };
  
  # Firefox
  programs.firefox.enable = false;
  
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
  
  # Zoxide, cd made easier
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
  
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
  
  # Not necessary, used tailscale instead
/*
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };
*/
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
/*  
    if you use "with pkgs;", elements inside the 
    list don't need the "pkgs.<pkgname>" syntax
    if you remove the "with pkgs;" line, then you will need to
    call below as pkgs.<pkgname> (which is what I prefer personally)
    why did I choose to remove pkgs.<pkgname>? MethLab 
*/
    matlab # Matlab for control systems and processing, WIP
    matlab-shell # Matlab-shell for installing MATLAB
    (pkgs.discord.override { enableAutoscroll = true; }) # Discord + Auto Scroll Option
    librewolf # Librewolf browser
    brave # Import Browser Profiles
    neovim # neovim text editor
    kdePackages.kate # Kate text editor
    btop # System Monitor
    sbctl # Secure Boot Control
    git # Self-explanatory
    openshot-qt # Video Editing
    gimp3 # Image Manipulation
    foliate # e-book reader
    wineWowPackages.waylandFull # Wine
    xournalpp # Note taking
    vlc # Media Player
    libreoffice-fresh # MSOffice Alternative
    gparted # Disk Partitioning
    prismlauncher # Minecraft
    zoom-us # Meetings
    arduino-ide # Programming
    gnome-tweaks # Nahida Cursors & Other Cool Stuff >.<
    (pkgs.callPackage ../../pkgs/cursors.nix {})
    papirus-icon-theme # Icon Theme
    gnomeExtensions.kimpanel # Input Method Panel
    gnomeExtensions.blur-my-shell # Blurring Appearance Tool
    gnomeExtensions.user-themes
  ];

  # Adds rocm support to btop and nixos
  nixpkgs.config.rocmSupport = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
/*
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
*/
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["Sumeezome"];
    };
  };
  
  # Enable tailscale VPN service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  
  # Fix tailscale auto-connect
  systemd.services.tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
  
  # Fix Gnome Keyring popup when using certain applications (Brave in my case)
  security.pam.services.gdm.enableGnomeKeyring = true;
  
  # Enable Firmware Updates
  services.fwupd.enable = true;
  
  # Open ports in the firewall.
/*  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1716 ]; # Port 1716 for KDEConnect, but I can just use tailscale lmao
    allowedUDPPorts = [ 1716 ];
  };
*/
/*
  This value determines the NixOS release from which the default
  settings for stateful data, like file locations and database versions
  on your system were taken. It‘s perfectly fine and recommended to leave
  this value at the release version of the first install of this system.
  Before changing this value read the documentation for this option
  (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
*/
  system.stateVersion = "24.11"; # Did you read the comment?
}
