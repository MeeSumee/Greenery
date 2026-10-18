{
  lib,
  config,
  ...
}: let
  data = "/run/media/sumee/emerald/services/suwayomi-server";
  port = "4567";
in {
  options.greenery.server.suwayomi.enable = lib.mkEnableOption "suwayomi";

  config = lib.mkIf (config.greenery.server.suwayomi.enable && config.greenery.server.enable) {
    # Add age secret files
    age.secrets.secret2 = {
      file = ../../secrets/secret2.age;
      mode = "0400";
    };

    virtualisation = {
      # Runtime
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
      };

      # Containers
      oci-containers.containers."suwayomi" = {
        pull = "newer";
        image = "ghcr.io/suwayomi/suwayomi-server:stable";
        autoStart = true;
        # Allows for autoupdate of containers
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        environment = {
          "TZ" = config.time.timeZone;

          # Network
          "BIND_IP" = "127.0.0.1";
          "BIND_PORT" = port;

          # Auth
          "AUTH_MODE" = "basic_auth";
          "AUTH_USERNAME" = "sumee";
          "AUTH_PASSWORD_FILE" = "/run/secrets/suwayomi_auth_password";

          # WebUI
          "WEB_UI_UPDATE_INTERVAL" = "0";

          # Cloudflare bypass
          "FLARESOLVERR_ENABLED" = "true";
          "FLARESOLVERR_URL" = "http://localhost:${builtins.toString config.services.flaresolverr.port}";
          "FLARESOLVERR_TIMEOUT" = "60";
          "FLARESOLVERR_SESSION_NAME" = "suwayomi";
          "FLARESOLVERR_SESSION_TTL" = "15";
          "FLARESOLVERR_RESPONSE_AS_FALLBACK" = "false";

          # Downloader
          "DOWNLOAD_AS_CBZ" = "true";
          "DOWNLOAD_CONVERSIONS" = ''{"image/webp":{"target":"image/jpeg"}}'';

          # Requests
          "MAX_SOURCES_IN_PARALLEL" = "6";

          # Updater
          "UPDATE_INTERVAL" = "24";

          # Backups
          "BACKUP_TIME" = "04:00";
          "BACKUP_INTERVAL" = "1";
          "BACKUP_TTL" = "14";

          # NOTE: extensionRepos, autoDownloadNewChapters, excludeEntryWithUnreadChapters,
          # autoDownloadIgnoreReUploads, excludeUnreadChapters, excludeNotStarted,
          # excludeCompleted and updateMangas have no environment variable equivalent in
          # the upstream docker image. They carry over from the preserved data directory
          # below and must be managed via the WebUI from now on.
        };
        volumes = [
          "/var/lib/suwayomi-server:/home/suwayomi/.local/share/Tachidesk:rw"
          "${data}/downloads:/home/suwayomi/.local/share/Tachidesk/downloads:rw"
          "${data}/local:/home/suwayomi/.local/share/Tachidesk/local:rw"
          "${data}/backups:/home/suwayomi/.local/share/Tachidesk/backups:rw"
          "${config.age.secrets.secret2.path}:/run/secrets/suwayomi_auth_password:ro"
        ];
        log-driver = "journald";
        extraOptions = [
          # Restrict permissions & only have what is defined
          "--security-opt=no-new-privileges:true"
          "--cap-drop=ALL"
          # Needed for the container runtime to switch from root to the
          # image's unprivileged "suwayomi" (uid 1000) user at startup
          "--cap-add=SETUID"
          "--cap-add=SETGID"

          # Use host networking to reach flaresolverr & be reverse-proxied via localhost
          "--network=host"
        ];
      };
    };

    services = {
      # Cloudflare bypass to ensure it can fetch mangas
      flaresolverr.enable = true;
      caddy = {
        enable = true;
        virtualHosts."https://manga.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/manga
            reverse_proxy localhost:${port}
          '';
        };
      };
    };

    systemd.services = {
      # Enable podman auto-update service
      "podman-auto-update".wantedBy = ["multi-user.target"];

      # Hardening
      "podman-suwayomi".serviceConfig = {
        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectSystem = "full";
        PrivateTmp = "disconnected";
        ProtectClock = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectProc = "invisible";
        PrivateMounts = true;
        RestrictRealtime = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        RemoveIPC = true;
        UMask = "0077";
      };

      # Podman hardening
      "podman".serviceConfig = {
        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectSystem = "full";
        PrivateTmp = "disconnected";
        ProtectClock = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectProc = "invisible";
        PrivateMounts = true;
        RestrictRealtime = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        RemoveIPC = true;
        UMask = "0077";
      };
    };
  };
}
