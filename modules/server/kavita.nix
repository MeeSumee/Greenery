{
  lib,
  config,
  pkgs,
  ...
}: {

  options.greenery.server.kavita.enable = lib.mkEnableOption "kavita hosting";
  
  config = lib.mkIf (config.greenery.server.kavita.enable && config.greenery.server.enable) {
    
    # Kavita manga hosting service
    services.kavita = {
      enable = true;
      tokenKeyFile = "/home/administrator/tokenkey/kkeygen";
      settings = {
        Port = 5000;
      };
    };
    
    # Komf java systemd
    systemd.services.komfjava = {
      wantedBy = [ "multi-user.target" ];
      after = [ "syslog.target" "network.target" ];
      description = "Start Komf Java program";

      serviceConfig = let 
        komfsrc = pkgs.fetchurl {
          url = "https://github.com/Snd-R/komf/releases/download/1.4.0/komf-1.4.0.jar";
          hash = "sha256-zzcXT/bMlWhgW+5V2brbbMWM6BJtthMXtlIaiVc3PEA=";
        };
      in {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = "${pkgs.jdk}/bin/java -jar ${komfsrc} /var/lib/kavita/application.yml";
      };
    };
  };
}
