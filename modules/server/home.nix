{
  lib,
  config,
  ...
}: {
  options.greenery.server.home.enable = lib.mkEnableOption "Home Assistant";

  config = lib.mkIf (config.greenery.server.home.enable && config.greenery.server.enable) {
    # Note that this service runs on <system-host>.<tailnet-name>.ts.net
    services.home-assistant = {
      enable = true;
      extraComponents = [
        "isal" # Faster Compression
        "matter" # For my smart plug
      ];
      config = {
        http = {
          server_port = 8123;
          # Thanks https://community.home-assistant.io/t/home-assistant-400-bad-request-docker-proxy-solution/322163
          use_x_forwarded_for = true;
          trusted_proxies = [
            "127.0.0.1"
            "::1"
          ];
        };
        homeassistant = {
          unit_system = "metric";
          time_zone = config.time.timeZone;
          temperature_unit = "C";
        };
      };
    };
  };
}
