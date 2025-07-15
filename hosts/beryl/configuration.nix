# Beryl Configuration
{
  config,
  pkgs,
  options,
  lib,
  inputs,
  ...
}: {
  imports = [
    # Imports.
    ../../modules/common
    ../../modules/gui
  ];

  networking.hostName = "beryl"; # The tint of blue I like
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Define user accounts.
  users.users = {
    sumeezome = {
      isNormalUser = true;
      description = "Sumeezome";
      extraGroups = ["networkmanager" "wheel" "fuse"];
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    foliate # e-book reader
  ];

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

  # Toggle cam on/off aliases using fish (need sudo privileges tho)
  programs.fish.shellAliases = {
    camoff = ''echo "5-1:1.0" | sudo tee /sys/bus/usb/drivers/uvcvideo/unbind'';
    camon = ''echo "5-1:1.0" | sudo tee /sys/bus/usb/drivers/uvcvideo/bind'';
  };
  
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
