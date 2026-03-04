{
  lib,
  config,
  ...
}:
{
  options.greenery.server.immich.enable = lib.mkEnableOption "Immich Photo & Video Sync";
  
  config = lib.mkIf (config.greenery.server.immich.enable && config.greenery.server.enable) {

    services = {
      immich = {
        enable = true;

        mediaLocation = "/run/media/sumee/emerald/immich";
        machine-learning.enable = false;

        host = "0.0.0.0";

        # Intel QSV accel Device
        accelerationDevices = [
          "/dev/dri/renderD129"
        ];
      };
    };

    users.users.immich.extraGroups = [ "video" "render" ];
  };
}
