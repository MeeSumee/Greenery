{
  lib,
  config,
  ...
}: {
  options.greenery.server.home.enable = lib.mkEnableOption "Home Assistant";

  config = lib.mkIf (config.greenery.server.home.enable && config.greenery.server.enable) {
    # Podman container cause being declarative got annoying especially when the fucking phone got involved
    virtualisation = {
      # Runtime
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
      };

      # Containers
      oci-containers.containers."hass" = {
        pull = "newer";
        image = "ghcr.io/home-assistant/home-assistant:stable";
        environment.TZ = config.time.timeZone;
        volumes = [
          "/var/lib/hass:/config:rw"
          "/run/dbus:/run/dbus:ro"
        ];
        log-driver = "journald";
        extraOptions = [
          # Restrict permissions & only have what is defined
          "--security-opt=no-new-privileges:true"
          "--cap-drop=ALL"
          "--cap-add=NET_RAW"
          "--cap-add=NET_ADMIN"
          "--cap-add=CHOWN"
          "--cap-add=DAC_OVERRIDE"
          "--cap-add=FSETID"
          "--cap-add=FOWNER"
          "--cap-add=SETGID"
          "--cap-add=SETUID"
          "--cap-add=SYS_CHROOT"
          "--cap-add=KILL"

          # Use host networking
          "--network=host"
        ];
      };
    };

    services = {
      caddy = {
        enable = true;
        virtualHosts."https://home.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/home
            reverse_proxy localhost:8123
          '';
        };
      };
    };

    # Hardening
    systemd.services = {
      "podman-hass".serviceConfig = {
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
