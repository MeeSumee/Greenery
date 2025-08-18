{ 
  lib, 
  config,
  pkgs,
  ... 
}: let

  revision = "v0.0.0-20250508175905-642f61fea3cc";

in {

  imports = [
    ./davis.nix
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
        hash = "sha256-K4K3qxN1TQ1Ia3yVLNfIOESXzC/d6HhzgWpC1qkT22k=";
      };
      
      # Age file has contents TS_AUTH=<insert your auth key>
      globalConfig = ''
        tailscale {
          auth_key {$TS_AUTH}
        }
      '';
    };
  };
}
