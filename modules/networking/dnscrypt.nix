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
   
    # DNS Proxy for DNS Resolving in Tailscale
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

          kaolin fd7a:115c:a1e0::5834:156
          beryl fd7a:115c:a1e0::8801:df69
          quartz fd7a:115c:a1e0::ff01:637f
          graphite fd7a:115c:a1e0::b534:9e21
          garnet fd7a:115c:a1e0::ec01:c948
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

        # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
        server_names = [
          "cloudflare"
          "cloudflare-ipv6"
        ];
      };
    };
  };
}
