{
  lib,
  config,
  ...
}: {
  options.greenery.server.vaultwarden.enable = lib.mkEnableOption "vaultwarden service";

  config = lib.mkIf (config.greenery.server.vaultwarden.enable && config.greenery.server.enable) {
    # Environments
    age.secrets.secret8.file = ../../secrets/secret8.age;

    # Vaultwarden Server
    services = {
      vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
        configurePostgres = true;
        environmentFile = config.age.secrets.secret8.path;
        config = {
          DOMAIN = "https://vault.onca-ph.ts.net";
          SIGNUPS_ALLOWED = false;
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          ROCKET_LOG = "critical";
        };
      };
      caddy = {
        enable = true;
        virtualHosts."https://vault.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/vault
            reverse_proxy localhost:${builtins.toString config.services.vaultwarden.config.ROCKET_PORT}
          '';
        };
      };
    };
  };
}
