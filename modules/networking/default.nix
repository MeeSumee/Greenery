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
    ./taildrive.nix
    ./tailscale.nix
  ];

  options.greenery.networking.enable = lib.mkEnableOption "networking";

  config = lib.mkIf config.greenery.networking.enable {
    # Enable network manager
    networking.networkmanager.enable = true;

    # NM hardening
    systemd.services = {
      NetworkManager.serviceConfig = {
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = "disconnected";
        PrivateMounts = true;
        ProtectClock = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
      NetworkManager-dispatcher.serviceConfig = {
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = "disconnected";
        PrivateMounts = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
  };
}
