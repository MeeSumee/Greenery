{
  lib,
  pkgs,
  config,
  options,
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

    # Add default nameservers for tailscale to use
    networking.nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    
    # Enable DNS Resolver as per nixos wiki
    services.resolved = {
      enable = true;
      dnssec = "true";
      domains = ["~."];
      fallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      dnsovertls = "true";  
    };
  };
}
