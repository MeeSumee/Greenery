# Verdure Configuration
{
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
      nvim.enable = true;
    };

    server = {
      enable = true;
      anki.enable = true;
      auth.enable = true;
      davis.enable = true;
    };

    system = {
      enable = true;
      fish.enable = true;
      sumee.enable = true;
    };
  };

  # Alias for Greenery
  networking.hostName = "verdure";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Pi programs
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  # Set borg backup service for services
  services.borgbackup.jobs = {
    grass = {
      paths = [
        "/var/lib/private/anki-sync-server"
        "/var/lib/davis"
        "/var/lib/2fauth"
      ];
      repo = "/mnt/verback";
      encryption.mode = "none";
      compression = "auto,zstd";
      startAt = "Mon 04:00:00";

      # Mount taildrive on demand
      preHook = ''
        ${pkgs.sshfs}/bin/sshfs -o \
        allow_other,default_permissions,compression=yes,cache=yes,auto_cache,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/sumee/.ssh/id_ed25519 \
        sumee@greenery:/run/media/sumee/emerald /mnt
      '';

      # Unmount the drive when completed/failed
      postHook = ''
        ${pkgs.umount}/bin/umount -l /mnt
      '';
    };
  };

  # Open tailscale firewall ports
  networking = {
    firewall = {
      allowedUDPPorts = [53];
      interfaces."tailscale0".allowedTCPPorts = [
        3600
        8000
        27701
      ];
    };
  };

  # Define US dnscrypt proxy config
  services.dnscrypt-proxy.settings = {
    listen_addresses = [
      "100.90.207.85:53"
      "[fd7a:115c:a1e0::8034:cf55]:53"
      "127.0.0.1:53"
      "[::1]:53"
    ];
  };
  
  # Exit-node flags
  services.tailscale = {
    extraSetFlags = [
      "--advertise-exit-node"
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
