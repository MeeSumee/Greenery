{ 
  config, 
  lib, 
  users, 
  ... 
}:
{
  options.greenery.networking.taildrive.enable = lib.mkEnableOption "taildrive";

  config = lib.mkIf (config.greenery.networking.taildrive.enable && config.greenery.networking.enable) {

    # Set taildrive to mount in user folder (very cursed lol)
    fileSystems."/run/media/${builtins.concatStringsSep "," users}/taildrive" = {
      device = "administrator@greenery:/run/media/sumee/emerald";
      fsType = "sshfs";
      options = [
        "allow_other"
        "umask=003"
        "_netdev"
        "x-systemd.automount"
        "reconnect"
        "ServerAliveInterval=15"
        "IdentityFile=${builtins.concatStringsSep "," (builtins.map (user: "${config.users.users.${user}.home}/.ssh/id_ed25519") users)}"
      ];
    };
  };
}
