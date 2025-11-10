{ 
  lib, 
  config,
  pkgs,
  ... 
}: let

  revision = "v0.0.0-20251102144943-aea8960a2d3c";

in {

  imports = [
    ./davis.nix
    ./files.nix
    ./jellyfin.nix
    ./suwayomi.nix
  ];
  
  options.greenery.server.enable = lib.mkEnableOption "enable server modules";

  
  config = lib.mkIf config.greenery.server.enable {
  
    # Age secret for caddy
    age.secrets.secret1.file = ../../secrets/secret1.age;

    services.caddy = {
      environmentFile = config.age.secrets.secret1.path;
      
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/tailscale/caddy-tailscale@${revision}" ];
        hash = "sha256-CIxEPu+4XO5upkYgtRJejNFWFDycS1LkIXppM+mSVAA=";
      };
      
      # Age file has contents TS_AUT=<insert your auth key>
      globalConfig = ''
        tailscale {
          auth_key {$TS_AUT}
        }
      '';
    };
  };
}
