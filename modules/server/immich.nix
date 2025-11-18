{
  lib,
  config,
  ...
}:
{
  options.greenery.server.immich.enable = lib.mkEnableOption "Immich Photo & Video Sync";
  
  config = lib.mkIf (config.greenery.server.immich.enable && config.greenery.server.enable) {

    services = {
      caddy = {
        enable = true;
        virtualHosts."https://immich.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/immich

            reverse_proxy localhost:2283
          '';
        };
      };

      immich = {
        enable = true;

        mediaLocation = "/run/media/sumee/emerald/immich";
        machine-learning.enable = false;

        # Intel QSV accel Device
        accelerationDevices = [
          "/dev/dri/renderD129"
        ];
      };
    };

    users.users.immich.extraGroups = [ "video" "render" ];
  };
}
