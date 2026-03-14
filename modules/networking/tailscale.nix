{
  lib,
  config,
  ...
}: {
  options.greenery.networking.tailscale.enable = lib.mkEnableOption "tailscale";

  config = lib.mkIf (config.greenery.networking.tailscale.enable && config.greenery.networking.enable) {
    # Enable tailscale VPN service
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both"; # Enables the use of exit node
      extraSetFlags = [
        "--accept-routes"
        "--accept-dns=false"
      ];
    };

    networking = {
      nftables.enable = true;
      firewall.allowedUDPPorts = [config.services.tailscale.port];
    };

    systemd.services = {
      tailscaled.serviceConfig = {
        # Force tailscaled to use nftables
        Environment = [
          "TS_DEBUG_FIREWALL_MODE=nftables"
        ];

        # Systemd-hardening
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

      # Stop wait-online service
      NetworkManager-wait-online.enable = false;

      # Fix system hang when no internet connection
      tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
    };

    boot.initrd.systemd.network.wait-online.enable = false;
  };
}
