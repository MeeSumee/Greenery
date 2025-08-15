{
  lib,
  config,
  pkgs,
  ...
}: let

  revision = "v0.0.0-20250508175905-642f61fea3cc";

in {

  options.greenery.server.suwayomi.enable = lib.mkEnableOption "suwayomi";
  
  config = lib.mkIf (config.greenery.server.suwayomi.enable && config.greenery.server.enable) {
    
    # Add age secret file
    age.secrets.secret1.file = ../../secrets/secret1.age;
    
    services = {

      # Caddy reverse-proxy using tailscale-caddy plugin
      caddy = {
        enable = true;
        
        environmentFile = config.age.secrets.secret1.path;
        
        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/tailscale/caddy-tailscale@${revision}" ];
          hash = "sha256-K4K3qxN1TQ1Ia3yVLNfIOESXzC/d6HhzgWpC1qkT22k=";
        };
        
        # Age file has contents TS_AUTH=<insert your auth key>
        globalConfig = ''
          tailscale {
            auth_key {$TS_AUTH}
          }
        '';

        virtualHosts."https://manga.berylline-mine.ts.net" = {
          extraConfig = ''
            bind tailscale/manga
            reverse_proxy localhost:4567
          '';
        };
      };

      # Suwayomi-server for fetching manga online
      suwayomi-server = {
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
