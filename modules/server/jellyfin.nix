{
  pkgs,
  lib,
  config,
  ...
}: {
  options.greenery.server.jellyfin.enable = lib.mkEnableOption "jellyfin service";

  config = lib.mkIf (config.greenery.server.jellyfin.enable && config.greenery.server.enable) {
    # Streaming Host
    services = {
      jellyfin = {
        enable = true;
        forceEncodingConfig = true;
        hardwareAcceleration = {
          enable = true;
          device = "/dev/dri/renderD128";
          type = "qsv";
        };
        transcoding = {
          enableHardwareEncoding = true;
          hardwareDecodingCodecs = {
            h264 = true;
            hevc = true;
            hevc10bit = true;
            vc1 = true;
            vp9 = true;
          };
        };
      };
      caddy = {
        enable = true;
        virtualHosts."https://jellyfin.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/jellyfin
            reverse_proxy localhost:8096
          '';
        };
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

    users.users.jellyfin.extraGroups = ["video" "render"];
  };
}
