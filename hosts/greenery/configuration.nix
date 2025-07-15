# Greenery Configuration
{ inputs, lib, config, pkgs, ... }:

{
  imports = [
      ../../modules/common
  ];

  networking.hostName = "greenery"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.dnscrypt-proxy2.settings = {
    listen_addresses = [
      "100.81.192.125:53"
      "[fd7a:115c:a1e0::d501:c081]:53"
      "127.0.0.1:53"
      "[::1]:53"
    ];
  };

  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Define a user account.
  users.users.administrator = {
    isNormalUser = true;
    description = "Administrator";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [  
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHITLg3/cEFB883XDG1KnaSmEAkYbqOBJMziWmfEadqO ナヒーダの白い髪"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwTjZGFn9J8wwwSAxfIirryeMBBLofBNF7fZ40engRh はとっても可愛いですよ"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIX4OMIF84eVKP5JqtAoE0/Wqd8c8cY2gAsXsKPC8C+X 本当に愛してぇる"
    ];
  };

  # Enable non-nix executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # Packages
  environment.systemPackages = with pkgs; [
    jdk21
    screen
  ];

  # List services that you want to enable:
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["administrator"];
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 3;
    ignoreIP = [
      "beryl.berylline-mine.ts.net"
      "garnet.berylline-mine.ts.net"
      "quartz.berylline-mine.ts.net"
    ];
    bantime = "48h";
    bantime-increment = {
      enable = true;
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      # multipliers = "1 2 4 8 16 32 64 128"; # same functionality as above
      # Do not ban for more than 10 weeks
      maxtime = "1680h";
      overalljails = true;
    };
  };

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
