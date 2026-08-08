{
  lib,
  config,
  ...
}: let
  port = "9283";
in {
  options.greenery.server.grocy.enable = lib.mkEnableOption "Grocy Podman Service";

  config = lib.mkIf (config.greenery.server.grocy.enable && config.greenery.server.enable) {
    virtualisation = {
      # Runtime
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
      };

      # Containers
      oci-containers.containers."grocy" = {
        pull = "newer";
        image = "lscr.io/linuxserver/grocy:latest";
        # Allows for autoupdate of containers
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        autoStart = true;
        environment = {
          PUID = "1000";
          GUID = "1000";
          TZ = config.time.timeZone;
        };
        volumes = [
          "/var/lib/grocy:/config:rw"
        ];
        ports = [
          "${port}:80/tcp"
        ];
        log-driver = "journald";
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts."https://grocy.onca-ph.ts.net" = {
        extraConfig = ''
          bind tailscale/grocy
          reverse_proxy localhost:${port}
        '';
      };
    };

    systemd.services = {
      # Enable podman auto-update service
      "podman-auto-update".wantedBy = ["multi-user.target"];

      # Hardening
      "podman-grocy".serviceConfig = {
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
