{
  lib,
  config,
  ...
}:
{
  options.greenery.server.memos.enable = lib.mkEnableOption "memos notetaking service";

  config = lib.mkIf (config.greenery.server.memos.enable && config.greenery.server.enable) {
    
    # Note-taking webserver
    services = {
      memos = {
        enable = true;
        dataDir = "/run/media/sumee/emerald/memos/";
      };
    };
  };
}

