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

      tailscale.serve.services.anki.endpoints."tcp:443" = "https://127.0.0.1:${builtins.toString config.services.anki-sync-server.port}";
    };
  };
}
