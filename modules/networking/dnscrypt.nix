{
  lib,
  pkgs,
  config,
  sources,
  ...
}: {
  options.greenery.networking.dnscrypt.enable = lib.mkEnableOption "dnscrypt";

  config = lib.mkIf (config.greenery.networking.dnscrypt.enable && config.greenery.networking.enable) {
    # Set DNS route
    networking = {
      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager.dns = lib.mkForce "none";
      nameservers = [
        "127.0.0.1"
        "::1"
      ];
    };

    services = {
      # Fuck this
      resolved.enable = false;

      # DNS Proxy for DNS Resolving with Tailscale Integration
      dnscrypt-proxy = {
        enable = true;
        settings = {
          ipv4_servers = true;
          ipv6_servers = true;
          doh_servers = true;
          require_dnssec = true;

          bootstrap_resolvers = [
            "9.9.9.11:53"
            "1.1.1.1:53"
          ];

          forwarding_rules = pkgs.writeText "forwarding_rules.txt" ''
            ts.net 100.100.100.100
          '';

          listen_addresses = [
            "127.0.0.1:53"
            "[::1]:53"
          ];

          cloaking_rules = pkgs.writeText "cloaking_rules.txt" ''
            greenery fd7a:115c:a1e0::c437:101d
            verdure fd7a:115c:a1e0::c737:c515
            kaolin fd7a:115c:a1e0::b637:7f6f
            seed fd7a:115c:a1e0::b037:4f52

            beryl fd7a:115c:a1e0::ec34:1779
            quartz fd7a:115c:a1e0::8c34:6d1e
            obsidian fd7a:115c:a1e0::c634:f339
          '';

          blocked_names.blocked_names_file = let
            extrablocklist = '''';
            blocklist = pkgs.writeText "blocklist.txt" ''
              ${extrablocklist}
              ${builtins.readFile (sources.blocklist + "/hosts")}
            '';
          in
            blocklist;

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
            "quad9-dnscrypt-ip4-nofilter-pri"
            "quad9-dnscrypt-ip6-nofilter-pri"
          ];
        };
      };
    };
  };
}
