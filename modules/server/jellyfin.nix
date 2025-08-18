{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.greenery.server.jellyfin.enable = lib.mkEnableOption "jellyfin service";

  config = lib.mkIf (config.greenery.server.jellyfin.enable && config.greenery.server.enable) {
    
    services = {
      
      # Caddy reverse-proxy using tailscale-caddy plugin
      caddy = {
        enable = true;
        virtualHosts."https://jellyfin.berylline-mine.ts.net" = {
          extraConfig = ''
            bind tailscale/jellyfin
            reverse_proxy localhost:8096
          '';
        };
      };

      # Streaming Host
      jellyfin = {
        enable = true;
        openFirewall = true;
      };
    };
    
    # Lemme find out if I actually need this :)
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
  };
}
