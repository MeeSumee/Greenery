{
  config,
  lib,
  ...
}: {
  options.greenery.programs.sunshine.enable = lib.mkEnableOption "sunshine";

  config = lib.mkIf (config.greenery.programs.sunshine.enable && config.greenery.programs.enable) {
    # Sunshine
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = false;
    };

    # Open tailscale firewall ports for sunshine
    networking.firewall.interfaces."tailscale0" = {
      allowedTCPPorts = [
        47984
        47989
        47990
        48010
      ];
      allowedUDPPorts = [
        47998
        47999
        48000
        48002
        48010
      ];
    };

    # I don't use HDMI so use it as a virtual-port so it plays nicely with Sunshine
    boot.kernelParams = ["video=HDMI-A-1:1920x1080R@60D"];
  };
}
