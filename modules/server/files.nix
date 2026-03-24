{
  lib,
  config,
  ...
}: {
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
      tailscale.serve.services.files.endpoints."tcp:443" = "https://127.0.0.1:${builtins.toString config.services.filebrowser.settings.port}";
    };
  };
}
