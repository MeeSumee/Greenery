# Start of Config
{
  config,
  pkgs,
  options,
  lib,
  modulesPath,
  flakeOverlays,
  inputs,
  ...
}: {
  imports = [
    # Imports.
    ../common.nix
    ../aagl.nix
    ../desktop.nix
    ../inputfont.nix
  ];

  networking.hostName = "beryl"; # The tint of blue I like
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Chicago";

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # Desktop Programs
    (pkgs.vesktop.override {
      withMiddleClickScroll = true;
      withSystemVencord = true;
    }) # Better discord + Overrides
    librewolf # Librewolf browser
    brave # Import Browser Profiles
    kdePackages.kate # Kate text editor
    foot # foot terminal
    sbctl # Secure Boot Control
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

    # Flake Packages
    (pkgs.callPackage ../../pkgs/cursors.nix {})
  ];

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
  
  # Fix tailscale auto-connect during login (might not be necessary)
  systemd.services.tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
  
  # Fix Gnome Keyring popup when using certain applications (Brave in my case)
  security.pam.services.gdm.enableGnomeKeyring = true;
  
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
