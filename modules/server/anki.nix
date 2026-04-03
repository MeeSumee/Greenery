{
  lib,
  config,
  ...
}: {
  options.greenery.server.anki.enable = lib.mkEnableOption "anki sync service";

  config = lib.mkIf (config.greenery.server.anki.enable && config.greenery.server.enable) {
    # PasswordFile
    age.secrets.secret1.file = ../../secrets/secret1.age;

    # Anki Sync Server
    services = {
      anki-sync-server = {
        enable = true;
        address = "0.0.0.0";
        port = 27701;

        users = [
          {
            username = "sumee";
            passwordFile = config.age.secrets.secret1.path;
          }
        ];
      };
      caddy = {
        enable = true;
        virtualHosts."https://anki.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/anki
            reverse_proxy localhost:${builtins.toString config.services.anki-sync-server.port}
          '';
        };
      };
    };
  };
}
