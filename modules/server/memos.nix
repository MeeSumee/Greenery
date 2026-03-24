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
        dataDir = "/run/media/sumee/emerald/memos/";
        settings = {
          MEMOS_MODE = "prod";
          MEMOS_ADDR = "127.0.0.1";
          MEMOS_PORT = "5230";
          MEMOS_DATA = config.services.memos.dataDir;
          MEMOS_DRIVER = "sqlite";
          MEMOS_INSTANCE_URL = "http://localhost:5230";
        };
      };
      tailscale.serve.services.memos.endpoints."tcp:443" = "https://127.0.0.1:${builtins.toString config.services.memos.settings.MEMOS_PORT}";
    };
  };
}
