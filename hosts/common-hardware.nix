{ config, lib, pkgs, modulesPath, user, ... }:{
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  fileSystems."/mnt/taildrive" = {
    device = "administrator@100.81.192.125:/run/media/sumee/taildrive";
    fsType = "sshfs";
    options = [
      "_netdev"
      "allow_other"
      "x-systemd.automount"
      "reconnect"
      "ServerAliveInterval=15"
      "IdentityFile=/home/${user}/.ssh/id_ed25519"
    ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
}