{
  lib,
  config,
  ...
}:
{

  options.greenery.server.suwayomi.enable = lib.mkEnableOption "suwayomi";
  
  config = lib.mkIf (config.greenery.server.suwayomi.enable && config.greenery.server.enable) {
    
    # Add age secret files
    age.secrets.secret2 = {
      file = ../../secrets/secret2.age;
      mode = "0400";
      owner = "suwayomi";
      group = "suwayomi";
    };

    services = {

      # Suwayomi-server for fetching manga online
      suwayomi-server = {
        enable = true;

        settings = {
          server = {
            ip = "0.0.0.0";
            port = 4567;

            # Auth
            basicAuthEnabled = true;
            basicAuthUsername = "sumee";
            basicAuthPasswordFile = config.age.secrets.secret2.path;
             
            # WebUI
            webUIEnabled = true;
            webUIFlavor = "WebUI";
            initialOpenInBrowserEnabled = false;
            webUIInterface = "browser";
            webUIChannel = "stable";

            # Downloader
            downloadAsCbz = true;
            downloadsPath = "/run/media/sumee/emerald/suwayomi";
            autoDownloadNewChapters = false;
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
  };
}
