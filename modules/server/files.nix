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
      caddy = {
        enable = true;
        virtualHosts."https://files.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/files
            reverse_proxy localhost:${builtins.toString config.services.filebrowser.settings.port}
          '';
        };
      };
    };
  };
}
