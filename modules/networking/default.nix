{
  lib,
  config,
  ...
}:{
  imports = [
    ./bluetooth.nix
    ./dnscrypt.nix
    ./fail2ban.nix
    ./openssh.nix
    ./taildrive.nix
    ./tailscale.nix
  ];

  options.greenery.networking.enable = lib.mkEnableOption "networking";

  config = lib.mkIf config.greenery.networking.enable {
    
    # Enable network manager
    networking = {
      networkmanager.enable = true;
    };
    
    # Stop wait-online service
    systemd.services.NetworkManager-wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
  };
}
