# Beryl Configuration
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
    ../programs.nix
    ../desktop.nix
    ../inputfont.nix
  ];

  networking.hostName = "quartz"; # The color of my desktop + piezoelectric shenanigans
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

  # Define user accounts
  users.users = {
    sumee = {
      isNormalUser = true;
      description = "Sumee";
      extraGroups = ["networkmanager" "wheel"];
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    audacity # Graphical Sound Editor
    kicad # Electronic CAD Designer
    komikku # Manga reading app
    fan2go # Fan Control
    openrgb # Open-Source RGB Control Software
    rare # Epic Games for Linux with GUI
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

  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["Sumee"];
    };
  };
  
  # Fix tailscale auto-connect during login (might not be necessary)
  systemd.services.tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
  
  # Open ports in the firewall.
/*  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
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
  system.stateVersion = "25.05"; # Did you read the comment?
}
