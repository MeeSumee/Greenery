{
  lib,
  config,
  ...
}:

{

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
            port = 3600;
          }
          {
            addr = "[::1]";
            port = 3600;
          }
        ];
      };
    };
  };
}
