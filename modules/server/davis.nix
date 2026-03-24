{
  lib,
  config,
  ...
}: let
  port = 3600;
in {
  options.greenery.server.davis.enable = lib.mkEnableOption "davis calendar";

  config = lib.mkIf (config.greenery.server.davis.enable && config.greenery.server.enable) {
    age.secrets = {
      secret1.file = ../../secrets/secret1.age;
      secret4.file = ../../secrets/secret4.age;
    };

    services = {
      davis = {
        enable = true;
        hostname = "localhost";

        adminLogin = "sumee";
        adminPasswordFile = config.age.secrets.secret1.path;
        appSecretFile = config.age.secrets.secret4.path;

        nginx.listen = [
          {
            addr = "0.0.0.0";
            port = port;
          }
          {
            addr = "[::1]";
            port = port;
          }
        ];
      };

      tailscale.serve.services.davis.endpoints."tcp:443" = "https://127.0.0.1:${builtins.toString port}";
    };

    # Based on https://github.com/alegrey91/systemd-service-hardening/blob/master/ansible/files/php-fpm.service
    systemd.services.phpfpm-davis.serviceConfig = {
      NoNewPrivileges = true;
    };
  };
}
