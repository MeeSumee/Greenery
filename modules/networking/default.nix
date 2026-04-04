{
  lib,
  config,
  ...
}: {
  imports = [
    ./bluetooth.nix
    ./dnscrypt.nix
    ./fail2ban.nix
    ./openssh.nix
    ./tailscale.nix
  ];

  options.greenery.networking.enable = lib.mkEnableOption "networking";

  config = lib.mkIf config.greenery.networking.enable {
    # Enable network manager & nftables
    networking = {
      networkmanager.enable = true;
      nftables.enable = true;

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      useDHCP = lib.mkDefault true;
    };

    # NM hardening
    systemd.services = {
      NetworkManager.serviceConfig = {
        ProtectHome = true;
        PrivateTmp = "disconnected";
        ProtectClock = true;
        ProtectKernelLogs = true;
        RestrictNamespaces = true;
        MemoryDenyWriteExecute = true;
      };
      NetworkManager-dispatcher.serviceConfig = {
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateUsers = true;
        PrivateDevices = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };
  };
}
