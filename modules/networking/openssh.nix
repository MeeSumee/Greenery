{
  lib,
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
      openFirewall = false;
      
      knownHosts = {
        "greenery".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiA3lkgGECrzk08GOhUlSIx5+jQ6WvuERK3nAz617M7";
      };

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = users;
      };
    };

    # Restrict ssh to only tailscale and not expose to public
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [22];

    # GPG Keys
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
