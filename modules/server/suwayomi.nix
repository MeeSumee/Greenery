{
  lib,
  config,
  pkgs,
  ...
}: {

  options.greenery.server.suwayomi.enable = lib.mkEnableOption "suwayomi";
  
  config = lib.mkIf (config.greenery.server.suwayomi.enable && config.greenery.server.enable) {

    # Suwayomi-server for fetching manga online
    services.suwayomi-server = {
      enable = true;
      openFirewall = false;

      settings = {
        server = {
          ip = "0.0.0.0";
          port = 4567;

          # Auth
          basicAuthEnabled = true;
          basicAuthUsername = "sumee";
          basicAuthPasswordFile = "/var/lib/suwayomi-server/suwa";
           
          # WebUI
          webUIEnabled = true;
          webUIFlavor = "WebUI";
          initialOpenInBrowserEnabled = false;
          webUIInterface = "browser";
          webUIChannel = "stable";

          # Downloader
          downloadAsCbz = true;
          downloadsPath = "/run/media/sumee/emerald/suwayomi";
          autoDownloadNewChapters = true;
          excludeEntryWithUnreadChapters = true;
          autoDownloadIgnoreReUploads = false;
          downloadConversions = {
            "image/webp" = {
              target = "image/jpeg";
            };
          };

          # Extension list
          extensionRepos = [
            "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
          ];

          # Requests
          maxSourcesInParallel = 6;

          # Updater
          excludeUnreadChapters = true;
          excludeNotStarted = true;
          excludeCompleted = true;
          globalUpdateInterval = 24;
          updateMangas = false;

          # Backups
          backupPath = "/run/media/sumee/emerald/suwabackups";
          backupTime = "04:00";
          backupInterval = 1;
          backupTTL = 14;
        };
      };
    };
  };
}
