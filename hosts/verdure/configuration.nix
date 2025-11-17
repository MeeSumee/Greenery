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
      headless.enable  = true;
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

  # Core programs for Pi set here temporarily
  environment.systemPackages = with pkgs; [
    git
    tree
    unzip
    fzf
    npins
    libraspberrypi
    raspberrypi-eeprom
  ];

  networking.firewall.allowedUDPPorts = [53 67];
  
  # Exit-node flags
  services.tailscale = {
    openFirewall = true;
    extraSetFlags = [
      "--advertise-exit-node"
      "--webclient"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
