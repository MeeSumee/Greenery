{
  lib,
  config,
  ...
}: {
  options.greenery.server.webserver.enable = lib.mkEnableOption "host a website";

  config = lib.mkIf (config.greenery.server.webserver.enable && config.greenery.server.enable) {
    # Webserver
    services = {
      caddy = {
        enable = true;
        openFirewall = true;
        virtualHosts."greenery.cc" = {
          extraConfig = ''
            root * /var/www/greenery.cc/public
            encode gzip
            file_server {
              hide .git
              hide README.md
              hide LICENSE
            }

            log {
              output file /var/log/caddy/greenery.log
            }

            tls {
              dns cloudflare {$CF_TOKEN}
            }
          '';
        };
      };
    };
  };
}
