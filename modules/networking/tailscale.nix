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
    };

    # Fix tailscale auto-connect during login (might not be necessary)
    systemd.services.tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
  };
}
