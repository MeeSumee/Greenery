{
  lib,
  config,
  ...
}:

{

  options.greenery.server.davis.enable = lib.mkEnableOption "davis calendar";
  
  config = lib.mkIf (config.greenery.server.davis.enable && config.greenery.server.enable) {

    age.secrets = {
      secret3.file = ../../secrets/secret3.age;
      secret4.file = ../../secrets/secret4.age;
    };

    services = {
      
      caddy = {
        enable = true;
        virtualHosts."https://davis.berylline-mine.ts.net" = {
          extraConfig = ''
            bind tailscale/davis

            reverse_proxy localhost:80
          '';
        };
      };

      davis = {
        enable = true;
        hostname = "localhost";

        adminLogin = "sumee";
        adminPasswordFile = config.age.secrets.secret3.path;
        appSecretFile = config.age.secrets.secret4.path;

        # config = {};
      };
    };
  };
}
