# Beryl Configuration
{
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
      hypridle.enable = true;
      niri.enable = true;
      sddm.enable = true;
      xserver.enable = true;
    };

    hardware = {
      enable = true;
      amdgpu.enable = true;
      audio.enable = true;
      power.enable = true;
    };

    networking = {
      enable = true;
      bluetooth.enable = true;      
      dnscrypt.enable = true;
      openssh.enable = true;
      taildrive.enable = true;
      tailscale.enable = true;
    };

    programs = {
      enable = true;
      browser.enable = true;
      foot.enable = true;
      core.enable = true;
      daemon.enable = true;
      desktop.enable = true;
      nvim.enable = true;
      steam.enable = true;
    };

    system = {
      enable = true;
      fish.enable = true;
      fonts.enable = true;
      input.enable = true;
      lanzaboote.enable = true;
      sumee.enable = true;
    };
  };

  networking.hostName = "beryl"; # The tint of blue I like
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Chicago";
  
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
