{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.greenery.server.jellyfin.enable = lib.mkEnableOption "jellyfin service";

  config = lib.mkIf (config.greenery.server.jellyfin.enable && config.greenery.server.enable) {
    
    services = {

      # Streaming Host
      jellyfin = {
        enable = true;
      };
    };
    
    # Lemme find out if I actually need this :)
    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    users.users.jellyfin.extraGroups = [ "video" "render" ];
  };
}
