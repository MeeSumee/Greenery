{
  lib,
  options,
  config,
  users,
  ...
}:{
  options.greenery.networking.openssh.enable = lib.mkEnableOption "openssh";

  config = lib.mkIf (config.greenery.networking.openssh.enable && config.greenery.networking.enable) {

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      
      knownHosts = {
        "greenery".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiA3lkgGECrzk08GOhUlSIx5+jQ6WvuERK3nAz617M7";
      };

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = users;
      };
    };
  };
}