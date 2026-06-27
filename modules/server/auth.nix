{
  lib,
  config,
  ...
}: let
  port = "8000";
in {
  options.greenery.server.auth.enable = lib.mkEnableOption "2FAuth Podman Service";

  config = lib.mkIf (config.greenery.server.auth.enable && config.greenery.server.enable) {
    # Agenix secret
    age.secrets.secret3.file = ../../secrets/secret3.age;

    virtualisation = {
      # Runtime
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
      };

      # Containers
      oci-containers.containers."2fauth" = {
        pull = "newer";
        image = "docker.io/2fauth/2fauth:latest";
        autoStart = true;
        environmentFiles = [config.age.secrets.secret3.path];
        # Allows for autoupdate of containers
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        environment = {
          "APP_ENV" = "production";
          "APP_URL" = "https://auth.onca-ph.ts.net";
          "ASSET_URL" = "https://auth.onca-ph.ts.net";
          "DB_CONNECTION" = "sqlite";
          "DB_DATABASE" = "/srv/database/database.sqlite";
        };
        volumes = [
          "/var/lib/2fauth:/2fauth:rw"
        ];
        ports = [
          "${port}:${port}/tcp"
        ];
        log-driver = "journald";
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts."https://auth.onca-ph.ts.net" = {
        extraConfig = ''
          bind tailscale/auth
          reverse_proxy localhost:${port}
        '';
      };
    };

    systemd.services = {
      # Enable podman auto-update service
      "podman-auto-update".wantedBy = ["multi-user.target"];

      # Hardening
      "podman-2fauth".serviceConfig = {
        ProtectHome = true;
        ProtectSystem = true;
        PrivateTmp = "disconnected";
        ProtectClock = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        PrivateMounts = true;
        RestrictRealtime = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        RemoveIPC = true;
      };

      # Podman hardening
      "podman".serviceConfig = {
        ProtectHome = true;
        ProtectSystem = true;
        PrivateTmp = "disconnected";
        ProtectClock = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        PrivateMounts = true;
        RestrictRealtime = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        RemoveIPC = true;
      };
    };
  };
}
