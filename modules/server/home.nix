{
  lib,
  config,
  ...
}: {
  options.greenery.server.home.enable = lib.mkEnableOption "Home Assistant";

  config =
    lib.mkIf (config.greenery.server.home.enable && config.greenery.server.enable) {
      services = {
        home-assistant = {
          enable = true;
          extraComponents = [
            "isal" # Faster Compression
            "matter" # For my smart plug
          ];
          config = {
            http = {
              server_host = [
                "0.0.0.0"
                "::"
              ];
              server_port = 8123;
            };
            homeassistant = {
              unit_system = "metric";
              time_zone = config.time.timeZone;
              temperature_unit = "C";
            };
          };
        };

        tailscale.serve.services.home.endpoints."tcp:443" = "https://127.0.0.1:${builtins.toString config.
services.home-assistant.config.http.server_port}";
      };
    };
}
