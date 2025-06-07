# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "greenery"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # don't resolve dns over dhcpd or networkmanager
  networking = {
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = lib.mkForce "none";
    nameservers = [
      "::1"
      "127.0.0.1"
    ];
  };

  services.dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv4_servers = true;
        ipv6_servers = true;
        doh_servers = true;
        require_dnssec = true;

        forwarding_rules = pkgs.writeText "forwarding_rules.txt" ''
          ts.net 100.100.100.100
        '';

        cloaking_rules = pkgs.writeText "cloaking_rules.txt" ''
          greenery fd7a:115c:a1e0::d501:c081
        '';

        listen_addresses = [
          "100.81.192.125:53"
          "[fd7a:115c:a1e0::d501:c081]:53"
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

  # Define a user account.
  users.users.administrator = {
    isNormalUser = true;
    description = "Administrator";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [  
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAm49EzRUJgTjDvDswdUV3hXkJN5DbzUZiKT/EQGOssz nahida@sumee.kusa"
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwTjZGFn9J8wwwSAxfIirryeMBBLofBNF7fZ40engRh stevemorrow69420@gmail.com"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
	"nix-command"
	"flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
        pkgs.wget
	pkgs.neovim
	pkgs.unzip
	pkgs.jdk11
	pkgs.speedtest-cli
	pkgs.tree
	pkgs.lm_sensors
	pkgs.screen
	pkgs.git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
