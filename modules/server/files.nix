{
  lib,
  config,
  ...
}:
{
  options.greenery.server.files.enable = lib.mkEnableOption "filebrowser service";

  config = lib.mkIf (config.greenery.server.files.enable && config.greenery.server.enable) {
    
    services = {
      
      # Caddy reverse-proxy using tailscale-caddy plugin
      caddy = {
        enable = true;
        virtualHosts."https://files.berylline-mine.ts.net" = {
          extraConfig = ''
            bind tailscale/files
            reverse_proxy localhost:6969
          '';
        };
      };

      # FileBrowser service
      filebrowser = {
        enable = true;
        openFirewall = true;

        settings = {
          root = "/run/media/sumee/emerald";
          port = 6969;
        };
      };
    };
  };
}
