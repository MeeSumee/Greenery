{
  pkgs,
  lib,
  config,
  ...
}:
{
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
          "ServiceNow-AI/Apriel-1.6-15b-Thinker:Q4_K_M"
          "ministral-3:14b"
          "qwen3-embedding:8b"
        ];
      };

      open-webui = {
        enable = true;
        port = 2127;
        environment = {
          OLLAMA_API_BASE_URL = "http://${config.services.ollama.host}:${builtins.toString config.services.ollama.port}";
          DO_NOT_TRACK = "True";
          SCARF_NO_ANALYTICS = "True";
        };
      };
    };
  };
}
