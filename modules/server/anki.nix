{
  lib,
  config,
  ...
}:
{
  options.greenery.server.anki.enable = lib.mkEnableOption "anki sync service";

  config = lib.mkIf (config.greenery.server.anki.enable && config.greenery.server.enable) {
    
    # PasswordFile
    age.secrets.secret1.file = ../../secrets/secret1.age;

    # Anki Sync Server
    services = {
      anki-sync-server = {
        enable = true;
        port = 27701;
        baseDirectory = "/run/media/sumee/taildrive/anki/";

        users = [{
          username = "sumee";
          passwordFile = config.age.secrets.secret1.path;
        }];
      };
    };
  };
}
