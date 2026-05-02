{
  lib,
  config,
  ...
}: {
  options.greenery.server.immich.enable = lib.mkEnableOption "Immich Photo & Video Sync";

  config = lib.mkIf (config.greenery.server.immich.enable && config.greenery.server.enable) {
    services = {
      immich = {
        enable = true;
        port = 2283;

        mediaLocation = "/run/media/sumee/emerald/services/immich";
        machine-learning.enable = false;

        host = "0.0.0.0";

        # Intel QSV accel Device
        accelerationDevices = [
          "/dev/dri/renderD128"
        ];
      };
      caddy = {
        enable = true;
        virtualHosts."https://immich.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/immich
            reverse_proxy localhost:${builtins.toString config.services.immich.port}
          '';
        };
      };
    };

    users.users.immich.extraGroups = ["video" "render"];
  };
}
