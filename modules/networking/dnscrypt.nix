{
  lib,
  pkgs,
  config,
  ...
}: {

  options.greenery.networking.dnscrypt.enable = lib.mkEnableOption "dnscrypt";

  config = lib.mkIf (config.greenery.networking.dnscrypt.enable && config.greenery.networking.enable) {

    # Set DNS route
    networking = {
      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager.dns = lib.mkForce "none";
      nameservers = [
        "::1"
        "127.0.0.1"
      ];
    };  
   
    # DNS Proxy for DNS Resolving with Tailscale Integration
    services.dnscrypt-proxy = {
      enable = true;
      settings = {
        ipv4_servers = true;
        ipv6_servers = true;
        doh_servers = true;
        require_dnssec = true;

        forwarding_rules = pkgs.writeText "forwarding_rules.txt" ''
          ts.net 100.100.100.100
        '';

        listen_addresses = [
          "127.0.0.1:53"
          "[::1]:53"
        ];

        cloaking_rules = pkgs.writeText "cloaking_rules.txt" ''
          greenery fd7a:115c:a1e0::d501:c081

          kaolin fd7a:115c:a1e0::3401:5a31
          beryl fd7a:115c:a1e0::8801:df69
          quartz fd7a:115c:a1e0::ff01:637f
          graphite fd7a:115c:a1e0::b534:9e21
          obsidian fd7a:115c:a1e0::2034:ae77
        '';

        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };

        # Quad9 Server chosen from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        server_names = [
          "quad9-dnscrypt-ip4-filter-pri"
          "quad9-dnscrypt-ip6-filter-pri"
        ];
      };
    };
  };
}
