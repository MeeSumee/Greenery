{
  pkgs,
  lib,
  config,
  ...
}: {
  options.greenery.server.ollama.enable = lib.mkEnableOption "ollama-openwebui service";

  config = lib.mkIf (config.greenery.server.ollama.enable && config.greenery.server.enable) {
    services = {
      ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
        syncModels = true;
        loadModels = [
          "gemma4:e4b"
          "qwen3.5:9b"
          "deepseek-r1:14b"
        ];
      };

      open-webui = {
        enable = true;
        port = 2127;
        environment = {
          ENABLE_OPENAI_API = "False";
          OLLAMA_BASE_URL = "http://${config.services.ollama.host}:${builtins.toString config.services.ollama.port}";
          DO_NOT_TRACK = "True";
          SCARF_NO_ANALYTICS = "True";
        };
      };

      caddy = {
        enable = true;
        virtualHosts."https://ai.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/ai
            reverse_proxy localhost:${builtins.toString config.services.open-webui.port}
          '';
        };
      };
    };

    # Harden model-loader
    systemd.services.ollama-model-loader.serviceConfig = {
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };
}
