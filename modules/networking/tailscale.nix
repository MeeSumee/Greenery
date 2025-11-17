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
        "--accept-routes=true"
        "--accept-dns=false"
      ];
    };

    networking = {
      firewall = {
        interfaces."tailscale0" = {
          allowedTCPPorts = [22];
          allowedUDPPorts = [53];
        };
      };
    };

    # Fix system hang when no internet connection
    systemd.services.tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
  };
}
