{
  lib,
  config,
  ...
}:
{
  options.greenery.server.docker.enable = lib.mkEnableOption "docker container";

  config = lib.mkIf (config.greenery.server.docker.enable && config.greenery.server.enable) {

    users.users.sumee.extraGroups = [ "docker" ];

    virtualisation.docker = {
      enable = true;

      daemon.settings = {
        dns = [ "1.1.1.1" "9.9.9.9" ];
        log-driver = "journald";
      };
      
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
