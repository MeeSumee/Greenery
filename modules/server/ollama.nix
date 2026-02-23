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
          "deepseek-r1:14b"
          "deepseek-ocr:3b"
          "gemma3:12b"
          "translategemma:12b"
          "ministral-3:14b"
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
    };
  };
}
