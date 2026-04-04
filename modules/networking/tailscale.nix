{
  lib,
  config,
  pkgs,
  ...
}: {
  options.greenery.networking.tailscale = {
    enable = lib.mkEnableOption "tailscale";
    exitNode = lib.mkEnableOption "tailscale exit node";
  };

  config = lib.mkIf (config.greenery.networking.tailscale.enable && config.greenery.networking.enable) {
    # Enable tailscale VPN service
    services = {
      tailscale = {
        enable = true;

        # Condition to check if system is client or server to ensure no forwarding
        useRoutingFeatures =
          if config.greenery.networking.tailscale.exitNode
          then "server"
          else "client";

        extraSetFlags = [
          "--accept-routes"
          "--accept-dns=false"
          (lib.mkIf config.greenery.networking.tailscale.exitNode "--advertise-exit-node")
        ];
      };

      # Tailscale Exit-Node Optimization
      networkd-dispatcher = lib.mkIf config.greenery.networking.tailscale.exitNode {
        enable = true;
        rules."50-tailscale-optimizations" = {
          onState = ["routable"];
          script = ''
            ${pkgs.ethtool}/bin/ethtool -K ens3 rx-udp-gro-forwarding on rx-gro-list off
          '';
        };
      };
    };

    # Allow tailscale ports
    networking = {
      firewall.allowedUDPPorts = [
        config.services.tailscale.port
        (lib.mkIf config.greenery.networking.tailscale.exitNode 53)
      ];
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
