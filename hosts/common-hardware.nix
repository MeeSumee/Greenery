{ config, lib, pkgs, modulesPath, users, ... }:{
  imports = [ 
    # Scan new/undetected hardware
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  
  # Define host platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Mount sshfs drive from greenery with mount on demand
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
  
  # Add greenery to known hosts to nixos
  services.openssh.knownHosts = {   
    "greenery".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiA3lkgGECrzk08GOhUlSIx5+jQ6WvuERK3nAz617M7";
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
}