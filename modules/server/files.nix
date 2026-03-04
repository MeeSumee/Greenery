{
  lib,
  config,
  ...
}:
{
  options.greenery.server.files.enable = lib.mkEnableOption "filebrowser service";

  config = lib.mkIf (config.greenery.server.files.enable && config.greenery.server.enable) {
    
    # FileBrowser service
    services = {
      filebrowser = {
        enable = true;

        settings = {
          root = "/run/media/sumee/emerald/data";
          port = 6969;
        };
      };
    };
  };
}
