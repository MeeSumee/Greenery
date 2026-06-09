{
  lib,
  config,
  ...
}: {
  options.greenery.server.motioneye.enable = lib.mkEnableOption "motioneye camera feed service";

  config = lib.mkIf (config.greenery.server.motioneye.enable && config.greenery.server.enable) {
    # MotionEye Server
    services = {
      motioneye = {
        enable = true;
        settings = {
          listen = "127.0.0.1";
          port = "8765";
          cleanup_interval = "43200";
          conf_path = lib.mkForce "/run/media/sumee/emerald/services/motioneye/conf";
          media_path = lib.mkForce "/run/media/sumee/emerald/services/motioneye/media";
        };
      };
      caddy = {
        enable = true;
        virtualHosts."https://motion.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/motion
            reverse_proxy localhost:${config.services.motioneye.settings.port}
          '';
        };
      };
    };
  };
}
