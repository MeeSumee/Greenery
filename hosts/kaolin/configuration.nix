# Kaolin Configuration
{
  config,  
  pkgs,
  ... 
}:{

  imports = [
    ../../modules
  ];

  # All modules and their values
  greenery = {
    enable = true;

    hardware = {
      enable = true;
    };

    networking = {
      enable = true;
      dnscrypt.enable = true;
      fail2ban.enable = true;
      openssh.enable = true;
      tailscale.enable = true;
    };

    programs = {
      enable = true;
      core.enable = true;
      nvim.enable = true;
    };

    system = {
      enable = true;
      fish.enable = true;
      sumee.enable = true;
    };
  };

  networking.hostName = "kaolin"; # Kaolin is (stopping) soft(ware from asking my ID)
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable Tailscale DNS-crypt forwarding
  networking.firewall.allowedUDPPorts = [53];

  # Define Swiss dnscrypt proxy config
  services.dnscrypt-proxy.settings = {
    listen_addresses = [
      "100.105.111.66:53"
      "[fd7a:115c:a1e0::9034:6f42]:53"
      "127.0.0.1:53"
      "[::1]:53"
    ];
  };

  # Enable IPv4 forwarding
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv4.conf.wgcf.rp_filter" = false;
  };

  # Agenix keyfile
  age.secrets.secret5.file = ../../secrets/secret5.age;

  # Wireguard config to not cuck tailscale
  networking.wg-quick.interfaces = {
    wgcf = {
      privateKeyFile = config.age.secrets.secret5.path;

      address = [
        "172.16.0.2/32"
        "2606:4700:110:84e2:34bb:cd8e:eefc:62cb/128"
      ];

      table = "off";

      postUp = ''
        set -e

        WG_IFACE=wgcf
        ROUTE_TABLE=39

        echo "[+] Adding nftables rules..."
        nft -f - <<EOF
        table inet ts-warp {
          chain prerouting {
            type filter hook prerouting priority mangle; policy accept;
            iifname "tailscale0" counter packets 0 bytes 0 meta mark set mark and 0xff00ffff or 0x0040000
          }
          chain input {
            type filter hook input priority filter; policy accept;
            iifname != "tailscale0" ip saddr 100.115.92.0/23 counter packets 0 bytes 0 return
            iifname != "tailscale0" ip saddr 100.64.0.0/10 counter packets 0 bytes 0 drop
            iifname "tailscale0" counter packets 0 bytes 0 accept
          }
          chain forward {
            type filter hook forward priority filter; policy accept;
            oifname "tailscale0" ip saddr 100.64.0.0/10 counter packets 0 bytes 0 drop
          }
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            meta mark & 0x00ff0000 == 0x00040000 counter packets 0 bytes 0 masquerade
          }
        }
        EOF

        echo "[+] Adding routing rule for marked packets..."
        ip route add default dev "$WG_IFACE" table $ROUTE_TABLE || true
        ip -6 route add default dev "$WG_IFACE" table $ROUTE_TABLE || true
        ip rule add fwmark 0x40000/0xff0000 lookup $ROUTE_TABLE || true
        ip -6 rule add fwmark 0x40000/0xff0000 lookup $ROUTE_TABLE || true
      '';

      preDown = ''
        set -e

        WG_IFACE=wgcf
        ROUTE_TABLE=39

        echo "[-] Deleting nftables rules..."
        nft delete table inet ts-warp || true

        echo "[-] Removing routing rules..."
        ip rule del fwmark 0x40000/0xff0000 lookup $ROUTE_TABLE || true
        ip -6 rule del fwmark 0x40000/0xff0000 lookup $ROUTE_TABLE || true
        ip route flush table $ROUTE_TABLE || true
        ip -6 route flush table $ROUTE_TABLE || true
      '';

      peers = [
        {
          publicKey = "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=";
          
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];

          endpoint = "162.159.192.1:2408";

          persistentKeepalive = 25;
        }
      ];
    };
  };


  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Add kaolin specific packages
  environment.systemPackages = with pkgs; [
    wgcf
    ethtool
  ];

  # Clear tmp cache on reboot
  boot.tmp.cleanOnBoot = true;

  # Use storage as additional RAM incase system runs out of memory (useful for low RAM VPS/VM instance)
  zramSwap.enable = true;

  # Exit-node flags
  services.tailscale = {
    extraSetFlags = [
      "--advertise-exit-node"
      "--advertise-routes=172.16.0.2/32"
      "--netfilter-mode=nodivert"
    ];
  };

  # Tailscale Exit-Node Optimization
  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale-optimizations" = {
      onState = [ "routable" ];
      script = ''
        ${pkgs.ethtool}/bin/ethtool -K ens3 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
