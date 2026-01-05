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

    networking.nftables.enable = true;
    networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

    # Force tailscaled to use nftables
    systemd.services.tailscaled.serviceConfig.Environment = [ 
      "TS_DEBUG_FIREWALL_MODE=nftables" 
    ];

    # Fix system hang when no internet connection
    systemd.services.tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
  };
}
