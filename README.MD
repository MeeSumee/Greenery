# My NixOS Repository
Consists of multiple devices:

- Greenery: Self-hosted Server with multiple services
- Beryl: Remote access, personal laptop for tinkering with Niri and Quickshell.
- Quartz: Gaming PC with attempts of iGPU Passthrough Windows.
- Kaolin: Swiss VPS acting as both an exit-node and a DNS Server.
- Graphite: Laptop found while dumpster diving and used as an excuse to use NixOS for work.

## Status Updates
 I've moved my PCI-Passthrough Config from Greenery to Quartz due to massive performance uplifts.
 However, I've been meaning to use the Intel UHD 770 iGPU to be passed through to the VM which
 has been a bitch as of late due to how Intel structured their GPUs to be more SR-IOV oriented
 rather than legacy PCI-Passthrough.

 Due to Greenery being more overkill as of late (5% CPU + 1.8GB/32GB util), Greenery hardware might
 be shifted over to the Raspberry Pi 4 with 8GB of RAM. Need to first configure the Pi for network
 routing for the NAS before adding all the server modules.

 I'm still kinda lazy in updating READMEs, I will try though.

## Notes on Banshell (and ricing in a way)

My rice themes have been more or less unified with rose pine, exceptions being nvim with TokyoNight and fuzzel with Catppuccin.

Xcursor-Genshin-Nahida will soon be packaged in a general way, fetching from Author's GitHub and
converted to Linux Cursors using ```pkgs.win2xcur```. This will also solve the licensing conflicts.

Banshell has been progressing slowly, interactable Nahida GIF in the works similar to kurukurubar.

Once the status tray is complete, Banshell will be merged to master as an alpha version where it can be optionally enabled.

I shall consult the Rexiel Scarlet to teach me how to package it.

Planned color themes:
- Matugen/JSON colorscheme schematic for Colors.qml
- Adapted Nahida/Vivian Colors for both Light & Dark Theme

# Greenery

Dell Optiplex 7050 that formerly was used as the primary exit-node to evade website blocks by my workplace.

Hosts Suwayomi for reading manga, Jellyfin for music (for now), Davis for Calendar and Contacts syncing, and
FileBrowser for a unified folder to connect between Android, Windows, and NixOS.

Implemented self-hosted websites using Caddy-Tailscale plugin and reverse-proxying localhost ports.

SSH services for file transfer and remote access. Enables sharing my 12TB hard drive (taildrive).

14TB Backup drive hosted on a Netgear Pro 6 with Tinycore Linux. Unfortunately failed to hook it up to Greenery via
Ethernet.

Future Endeavors: More functional Jellyfin, Proxy websites that do not involve with Kaolin, Decide Feasibility
of replacing the Optiplex 7050 with RPi 4.

# Kaolin

VPS that routes all traffic via Tailscale Exit-node while using wireguard as a bridge to connect tailscale
with Cloudflare-WARP. Also doubles as a DNS Proxy Server with dnscrypt-proxy resolving with Quad9

Infected Infomaniak's Debian with NixOS my beloved.

The system is nearly 100% declarative with the only exception of hardware config.

<details>
<summary>Why and How?</summary>
<br>

VPS IPs are generally blocked by most services online whereas Cloudflare Warp IPs are generally not blocked.
However, Cloudflare Warp chooses a server closest to the host machine, making it effectively useless for geolocation.

You may use cloudflare warp on the VPS to effectly connect to a regional server based on the VPS's location enabling 
you to use your VPS as a VPN. However, using another VPN such as tailscale can conflict with cloudflare warp's configuration.

To solve this problem, we must setup an interface that uniformly passes traffic from Tailscale to Cloudflare.
Wireguard is supported by both Tailscale and Cloudflare and can be used to set rules and nftables.

First, configure your own set of IPs and keys using [wgcf](https://github.com/ViRb3/wgcf) by executing

```bash
$ wgcf register
$ wgcf generate
```

This will provide the interface and peer information. Take note of them for setting up nftables.

To setup nftables and Wireguard interfaces

```nix
# configuration.nix

  # Enable nftables
  networking.nftables.enable = true;

  # Enable IPv4 forwarding
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv4.conf.wgcf.rp_filter" = false;
  };

  # Wireguard config to not cuck tailscale
  networking.wg-quick.interfaces = {
    wgcf = {
      privateKeyFile = "/path/to/privatekeyfile";

      address = [
        [Insert IPv4 from wgcf]
        [Insert IPv6 from wgcf]
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
          publicKey = [Insert your public key from wgcf];

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

  # Advertise Routes
  services.tailscale.extraSetFlags = [
    "--advertise-exit-node"
    "--advertise-routes=[Insert IPv4 from wgcf]"
    "--netfilter-mode=nodivert"
  ];
```

With this setup, it will enable you to use Tailscale as a way to connect to Cloudflare Warp, enabling your phone to use the machine as an exit node.

</details>

# Beryl

ASUSTek Zenbook S13 OLED formerly used for college, now is my plaything for managing nix configs whenever I'm not at home.

Problems: AMDGPU crash prevelent in mainly hardware-accelerated scenarios. Was also observed when Windows was installed.
Due to the issue being a relatively rare scenario (once every month or two), I'm not in a hurry to fix it.

Future Endeavors: Rice Banshell, fix AMDGPU crashes from Youtube/demanding HWAccel Tasks.

<details>
<summary>Enabling USB4 on Zenbook S13 OLED (UM5302TA)</summary>
<br>

This is not recommended for most users as it involves "hacking" the
BIOS. DO IT AT YOUR OWN RISK.

UM5302TA is one of the few laptops capable of USB4, but disabled by the
manufacturer due to potential instability with specific devices. 
Despite knowing the risk, I've decided to enable USB4 using 
[UniversalAMDFormBrowser](https://github.com/DavidS95/Smokeless_UMAF/blob/main/UniversalAMDFormBrowser.zip) by following this reddit [post](https://www.reddit.com/r/ASUS/comments/13omq1e/zenbook_s13_bios_update_for_usb_4_whats_going_on/).
Note that there are three options when enabling USB4.

To activate USB4 on NixOS, set ```services.hardware.bolt.enable``` to true.
Test your USB4 ports using boltctl, if there's instability, disable bolt service.

</details>

# Graphite

Dell Latitude 5400 found in the dumpster. Consisted of 16GB of RAM and 256GB NVME SSD. Pretty good find imo.

UPDATE: NixOS Stage 1 got fucked somehow, so I have to reinstall and reconfigure it. Gives me the opportunity
to unfuck my undeclarative python.

# Quartz

Custom-built gaming pc intended for workstation and gaming.

Intended to be used as my nix config manager while I'm at home.

Consists of (WIP) iGPU-Passthrough Windows 10 IoT LTSC Virtual Machine managed by libvirtd. Remote using
Sunshine + Moonlight via Tailscale.

Future Endeavors: Fix Error Code 43 in iGPU driver on Windows (not a problem on Linux VMs, it's windows being ASS)

## Quartz PC Specifications
- CPU: [Intel i9-12900K non-oxidizing edition](https://www.intel.com/content/www/us/en/products/sku/134599/intel-core-i912900k-processor-30m-cache-up-to-5-20-ghz/specifications.html)
- RAM: [GSkill Ripjaws S5 32GB DDR5-6000](https://www.gskill.com/products/1/165/377/Ripjaws-S5-DDR5-Intel-XMP)
- MB: [Gigabyte Z690 AORUS ELITE AX REV 1.4](https://www.gigabyte.com/Motherboard/Z690-AORUS-ELITE-AX-rev-14)
- GPU: [XFX SPEEDSTER MERC 319 AMD RX 6950 XT](https://www.xfxforce.com/shop/xfx-speedster-merc-319-amd-radeon-tm-rx-6950-xt-black)

## Credits
[Rexcrazy804](https://github.com/Rexcrazy804) for literally carrying me. HE NEEDS A JOB.
He also gets a lot of credit for all the code I've stolen with permission.

[Eel](https://github.com/zhuazhuzz) for his frontend expertise and helping me mald over quickshell design.

Several sources of quickshell code I've been browsing through in an attempt to understand wtf is going on:
[Outfoxxed](https://quickshell.outfoxxed.me/), [Soramane](https://github.com/caelestia-dots/shell), [Ly-sec](https://github.com/Ly-sec/nixos), [end_4 (Hi for swapped.txt)](https://github.com/end-4/dots-hyprland), [Rexcrazy804 (Hai~)](https://github.com/Rexcrazy804/Zaphkiel/tree/master/users/dots/quickshell/kurukurubar), [bbedward](https://github.com/bbedward/DankMaterialShell)

I also want to thank the folks of UAFB who made USB4 possible.

Lastly, I want to thank the Nix Community for its push for packages,
maintainers, and hardware support. I haven't had this much fun in
a while.

## Licensing
All code in this repository is under the MIT license unless wherever an
explicit licensing is included.

## Miscellaneous Sources
- [xcursor-genshin-nahida](https://aur.archlinux.org/packages/xcursor-samtoki-genshin-impact)
- [User Profile Picture (Nix & Git)](https://danbooru.donmai.us/posts/9246148)
- [Dell Optiplex 3050 Tower Specifications and Image](https://i.dell.com/sites/doccontent/shared-content/data-sheets/en/Documents/OptiPlex-3050-Towers-Technical-Specifications.pdf)
- [Rex's Kokomi Image I shamelessly removed for professionalism](https://danbooru.donmai.us/posts/9590836)
- [Vivian Banshee Wallpaper](https://danbooru.donmai.us/posts/9259057?q=vivian_banshee+pyogo)
- [ASUSTek Zenbook S13 OLED, ASUS removed the website :(](https://www.bestbuy.com/site/asus-zenbook-s-13-oled-um5302-13-3-laptop-amd-ryzen-7-16-gb-memory-1-tb-ssd-ponder-blue/6510809.p)
