# Kaolin Configuration (Swiss routing server hopefully running soon)
{ 
  lib, 
  ... 
}:{

  imports = [
    ../../modules
  ];

  # All modules and their values
  greenery = {
    enable = true;
    
    desktop = {
      enable = false;
      gdm.enable = false;
      gnome.enable = false;
      hypridle.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;
      kurukurudm.enable = false;
      niri.enable = false;
      xserver.enable = false;

      # sddm.nix isn't included and has no option
    };

    hardware = {
      enable = true;
      amdgpu.enable = false;
      audio.enable = false;
      intelgpu.enable = false;
    };

    networking = {
      enable = true;
      bluetooth.enable = false;
      dnscrypt.enable = true;
      fail2ban.enable = true;
      openssh.enable = true;
      taildrive.enable = false;
      tailscale.enable = true;
    };

    programs = {
      enable = true;
      aagl.enable = false;
      browser.enable = false;
      foot.enable = false;
      micro.enable = false;
      core.enable = true;
      server.enable  = true;
      daemon.enable = false;
      desktop.enable = false;
      engineering.enable = false;
      heavy.enable = false;
      nvim.enable = true;
      steam.enable = false;
      yazi.enable = true;
    };

    server = {
      enable = false;
      jellyfin.enable = false;
      suwayomi.enable = false;
    };

    system = {
      enable = true;
      fish.enable = true;
      fonts.enable = false;
      input.enable = false;
      lanzaboote.enable = false;

      # locale.nix included by default
      # nix.nix included by default
    };
  };

  networking.hostName = "kaolin"; # Kaolin is (stopping) soft(ware from asking my ID)
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set DNS route
  networking = {
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = lib.mkForce "none";
    nameservers = [
      "::1"
      "127.0.0.1"
    ];
  };  

  services.dnscrypt-proxy2.settings = {
    listen_addresses = [
      "100.73.1.86:53"
      "[fd7a:115c:a1e0::5834:156]:53"
      "127.0.0.1:53"
      "[::1]:53"
    ];
  };

  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Define a user account.
  users.users.sumee = {
    isNormalUser = true;
    description = "Sumee";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [  
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHITLg3/cEFB883XDG1KnaSmEAkYbqOBJMziWmfEadqO ナヒーダの白い髪"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwTjZGFn9J8wwwSAxfIirryeMBBLofBNF7fZ40engRh はとっても可愛いですよ"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIX4OMIF84eVKP5JqtAoE0/Wqd8c8cY2gAsXsKPC8C+X 本当に愛してぇる"
    ];
  };

  # Pre-generated config from nixos-infect
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  # Exit-node flags
  services.tailscale = {
    openFirewall = true;
    extraSetFlags = [
      "--advertise-exit-node"
      "--webclient"
      "--accept-dns=false"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
