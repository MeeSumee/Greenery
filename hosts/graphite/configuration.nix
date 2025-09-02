# Graphite Configuration
{
  ... 
}: {
  imports = [
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
      hyprland.enable = true;
      hyprlock.enable = false;
      kurukurudm.enable = true;
      niri.enable = false;
      xserver.enable = true;
    };

    hardware = {
      enable = true;
      amdgpu.enable = false;
      audio.enable = true;
      intelgpu.enable = true;
    };

    networking = {
      enable = true;
      bluetooth.enable = true;
      dnscrypt.enable = true;
      fail2ban.enable = false;
      openssh.enable = true;
      taildrive.enable = false;
      tailscale.enable = true;
    };

    programs = {
      enable = true;
      aagl.enable = false;
      browser.enable = true;
      foot.enable = true;
      micro.enable = false;
      core.enable = true;
      server.enable = false;
      daemon.enable = true;
      desktop.enable = true;
      engineering.enable = false;
      heavy.enable = false;
      nvim.enable = true;
      steam.enable = false;
      yazi.enable = false;
    };

    server = {
      enable = false;
      davis.enable = false;
      jellyfin.enable = false;
      suwayomi.enable = false;
    };

    system = {
      enable = true;
      fish.enable = true;
      fonts.enable = true;
      input.enable = true;
      lanzaboote.enable = true;
      sumee.enable = true;
      nahida.enable = false;
      yang.enable = false;

      # age.nix included by default
      # locale.nix included by default
      # nix.nix included by default
    };
  };

  networking.hostName = "graphite"; # The workplace grindset + friend made me do it
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
