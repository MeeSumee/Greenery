# Beryl Configuration
{
  config,
  pkgs,
  options,
  lib,
  ...
}: {
  imports = [
    # Imports.
    ../../modules
  ];
  
  # All modules and their values
  greenery = {
    enable = true;
    
    desktop = {
      enable = true;
      gdm.enable = false;
      gnome.enable = false;
      hypridle.enable = true;
      hyprland.enable = false;
      hyprlock.enable = true;
      kurukurudm.enable = true;
      niri.enable = true;
      xserver.enable = true;

      # sddm.nix isn't included and has no option
    };

    hardware = {
      enable = true;
      amdgpu.enable = true;
      audio.enable = true;
      intelgpu.enable = false;
    };

    networking = {
      enable = true;
      bluetooth.enable = true;      
      dnscrypt.enable = true;
      fail2ban.enable = false;
      openssh.enable = true;
      taildrive.enable = true;
      tailscale.enable = true;
    };

    programs = {
      enable = true;
      aagl.enable = false;
      browser.enable = true;
      foot.enable = true;
      micro.enable = false;
      core.enable = true;
      server.enable  = false;
      daemon.enable = true;
      desktop.enable = true;
      engineering.enable = true;
      heavy.enable = false;
      nvim.enable = true;
      steam.enable = true;
      yazi.enable = false;
    };

    server = {
      enable = false;
      jellyfin.enable = false;
      suwayomi.enable = false;
    };

    system = {
      enable = true;
      fish.enable = true;
      fonts.enable = true;
      input.enable = true;
      lanzaboote.enable = true;

      # locale.nix included by default
      # nix.nix included by default
    };
  };

  # Enables fingerprint authentication
  programs.kurukuruDM.settings.instantAuth = lib.mkForce true;

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

  # Toggle cam on/off aliases using fish (need sudo privileges tho)
  programs.fish.shellAliases = {
    camoff = ''echo "5-1:1.0" | sudo tee /sys/bus/usb/drivers/uvcvideo/unbind'';
    camon = ''echo "5-1:1.0" | sudo tee /sys/bus/usb/drivers/uvcvideo/bind'';
  };
  
  # Enable power profiles
  services.power-profiles-daemon.enable = true;
  
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
