# Verdure (soon greenery) Configuration
{
  config,
  pkgs,
  ... 
}:{

  imports = [
    ../../modules
  ];

  # All modules and their values
  greenery = {
    enable = true;

    hardware = {
      enable = true;
    };

    networking = {
      enable = true;
      dnscrypt.enable = true;
      fail2ban.enable = true;
      openssh.enable = true;
      tailscale.enable = true;
    };

    programs = {
      enable = true;
      core.enable = true;
      server.enable  = true;
      nvim.enable = true;
    };

    system = {
      enable = true;
      fish.enable = true;
      sumee.enable = true;
    };
  };


  networking.hostName = "verdure"; # Alias for Greenery

  # Set your time zone.
  time.timeZone = "America/Chicago";
}
