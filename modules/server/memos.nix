{
  lib,
  config,
  ...
}: {
  options.greenery.server.memos.enable = lib.mkEnableOption "memos notetaking service";

  config = lib.mkIf (config.greenery.server.memos.enable && config.greenery.server.enable) {
    # Note-taking webserver
    services = {
      memos = {
        enable = true;
        dataDir = "/run/media/sumee/emerald/services/memos/";
        settings = {
          MEMOS_MODE = "prod";
          MEMOS_ADDR = "127.0.0.1";
          MEMOS_PORT = "5230";
          MEMOS_DATA = config.services.memos.dataDir;
          MEMOS_DRIVER = "sqlite";
          MEMOS_INSTANCE_URL = "http://localhost:5230";
        };
      };
      caddy = {
        enable = true;
        virtualHosts."https://memos.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/memos
            reverse_proxy localhost:${config.services.memos.settings.MEMOS_PORT}
          '';
        };
      };
    };
  };
}
