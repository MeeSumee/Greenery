/*
⠀⠀⠀⠀⠀⠀⠀⣶⣄⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢸⣿⣿⣷⣴⣿⡄⠀⠀⠀⠀⠀⢀⡀⠀
⠀⠀⠀⠀⠰⣶⣾⣿⣿⣿⣿⣿⡇⠀⢠⣷⣤⣶⣿⡇⠀
⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣀⣿⣿⣿⣿⣿⣧⣀
⠀⠀⠀⣷⣦⣀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃
⢲⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀
⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀
⠀⠚⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠂⠀⠀
⠀⠀⠀⠀⠀⠉⠙⢻⣿⣿⡿⠛⠉⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠘⠋⠁⠀⠀⠀⠸⡄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡀⠀⠀⠀⠀⠀
*/
# Verdure Configuration
{
  pkgs,
  config,
  ...
}: {
  # All modules and their values
  greenery = {
    hardware.enable = true;

    networking = {
      enable = true;
      bluetooth.enable = true;
      dnscrypt.enable = true;
      fail2ban.enable = true;
      openssh.enable = true;
      tailscale.enable = true;
    };

    programs.enable = true;

    server = {
      enable = true;
      anki.enable = true;
      auth.enable = true;
      davis.enable = true;
      home.enable = true;
    };

    system = {
      enable = true;
      autoUpgrade.enable = true;
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

  # Agenix keyfile
  age.secrets.secret1.file = ../../secrets/secret1.age;

  services = {
    # Set borg backup service for services
    borgbackup.jobs = {
      grass = {
        paths = ["/var"];
        repo = "/mnt/verback";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "cat ${config.age.secrets.secret1.path}";
        };
        compression = "auto,zstd";
        startAt = "Mon 04:00:00";

        # Mount emerald on demand
        preHook = ''
          ${pkgs.sshfs}/bin/sshfs -o \
          allow_other,default_permissions,compression=yes,cache=yes,auto_cache,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,IdentityFile=/home/sumee/.ssh/id_ed25519 \
          sumee@seed:/mnt/raid /mnt
        '';

        # Unmount the drive when completed/failed
        postHook = ''
          ${pkgs.umount}/bin/umount -l /mnt
        '';
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
