{
  config,
  lib,
  ...
}: {
  options.greenery.programs.rustdesk.enable = lib.mkEnableOption "rustdesk";

  config = lib.mkIf (config.greenery.programs.rustdesk.enable && config.greenery.programs.enable) {
    # Rustdesk server
    services.rustdesk-server = {
      enable = true;
      relay.enable = false;
      signal.enable = false;
    };

    # Open tailscale firewall ports for rustdesk
    networking.firewall.interfaces."tailscale0" = {
      allowedTCPPorts = [
        21115
        21116
        21117
        21118
        21119
      ];
      allowedUDPPorts = [
        21116
      ];
    };
  };
}
