# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, modulesPath, ... }:

{
  imports =
    [
      # Imports
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  networking.hostName = "greeneryVM"; # Virtual Machine Name
  system.stateVersion = "25.05"; # Default State Version
  virtualisation = {
    graphics = false; # Enable Graphics
    diskSize = 10 * 1024; # Set Disk Size in GB
    memorySize = 4 * 1024; # Set Memory Allocation in GB
    cores = 2; # Set number of cores
    forwardPorts = [
      {
        from = "host";
        host.port = 8080; # Port 8080 for web access
        guest.port = 8080;
      }
    ];
  };

  users = {
    groups = {
      greenery = {};
    };
    users.greenery = {
      enable = true;
      initialPassword = "touchgrass";
      createHome = true;
      isNormalUser = true;
      uid = 1000;
      group = "greenery";
      extraGroups = ["wheel"];
    };
  };
  
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
/* Configure dhcpd
  # don't resolve dns over dhcpd or networkmanager
  networking = {
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = lib.mkForce "none";
    nameservers = [
      "::1"
      "127.0.0.1"
    ];
  };
*/
/* configure dnscrypt proxy & firewall here, replace (Text) with your configurations
  services.dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv4_servers = true;
        ipv6_servers = true;
        doh_servers = true;
        require_dnssec = true;

        forwarding_rules = pkgs.writeText "forwarding_rules.txt" ''
          (ts.net 100.100.100.100) # Tailscale IP
        '';

        cloaking_rules = pkgs.writeText "cloaking_rules.txt" ''
          (hostname) (IPv6 Address)
        '';

        listen_addresses = [
          "(IPv4 Address):53"
          "[(IPv6 Address)]:53"
          "127.0.0.1:53"
          "[::1]:53"
        ];

        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };

        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        server_names = [
          "cloudflare"
          "cloudflare-ipv6"
        ];
      };
    };

  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
*/
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	pkgs.neovim
	pkgs.jdk17
	pkgs.speedtest-cli
	pkgs.tree
	pkgs.lm_sensors
	pkgs.screen
	pkgs.git
  ];

  # List services that you want to enable:
  services.openssh = {
  	enable = true;
  };
/* Fail2Ban Service
  services.fail2ban = {
	enable = true;
        maxretry = 3;
        ignoreIP = [
          "nixos.wiki"
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
*/
/* Tailscale Service
  services.tailscale = {
  	enable = true;
	openFirewall = true;
	useRoutingFeatures = "both";
	extraSetFlags = [
	  "--advertise-exit-node"
	  "--webclient"
	  "--accept-dns=false"
	];
  };
*/
}
