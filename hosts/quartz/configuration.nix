# Quartz Configuration
{
  config,
  pkgs,
  options,
  lib,
  ...
}: {
  imports = [
    # Imports.
    ../../modules/common
    ../../modules/gui
  ];

  networking.hostName = "quartz"; # The color of my desktop + piezoelectric shenanigans
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Define user accounts
  users.users = {
    sumee = {
      isNormalUser = true;
      description = "Sumee";
      extraGroups = ["networkmanager" "wheel" "fuse"];
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
    davinci-resolve # Video Editing
  ];

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
