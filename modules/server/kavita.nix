{
  lib,
  config,
  ...
}: {
  options.greenery.server.kavita.enable = lib.mkEnableOption "kavita hosting";
  
  config = lib.mkIf (config.greenery.server.kavita.enable && config.greenery.server.enable) {
    services.kavita = {
      enable = true;
      tokenKeyFile = "/home/administrator/tokenkey/kkeygen";
      settings = {
        Port = 5000;
      };
    };
  };
}
