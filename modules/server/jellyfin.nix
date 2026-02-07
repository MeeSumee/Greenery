{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.greenery.server.jellyfin.enable = lib.mkEnableOption "jellyfin service";

  config = lib.mkIf (config.greenery.server.jellyfin.enable && config.greenery.server.enable) {

    # Streaming Host
    services = {
      jellyfin = {
        enable = true;
      };
    };

    # Hint Jellyfin Driver
    systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";

    # jellyfin plugins
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    users.users.jellyfin.extraGroups = [ "video" "render" ];
  };
}
