{
  lib,
  config,
  ...
}:
{
  options.greenery.server.memos.enable = lib.mkEnableOption "memos notetaking service";

  config = lib.mkIf (config.greenery.server.memos.enable && config.greenery.server.enable) {
    
    services = {
      # Caddy reverse-proxy using tailscale-caddy plugin
      caddy = {
        enable = true;
        virtualHosts."https://memos.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/memos
            reverse_proxy localhost:5230
          '';
        };
      };

      # Note-taking app
      # On mobile I use Moe Memos and connect it to memos
      memos = {
        enable = true;
        dataDir = "/run/media/sumee/emerald/memos/";
      };
    };
  };
}

