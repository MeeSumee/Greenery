# My NixOS Repository
Consists of multiple devices:

- Greenery: DNS, self-hosted, minecraft server with multiple services.
- Beryl: Remote access, personal laptop for tinkering with Niri and Quickshell.
- Quartz: Gaming PC for well, gaming.
- Kaolin: Traffic Relaying server to Switzerland using Cloudflare-WARP and Tailscale bridged using Wireguard.
- Graphite: Laptop found while dumpster diving and used as an excuse to use NixOS for work.

## Status Updates
 I AM STILL WAITING FOR ORACLE OMFG AAAHHHH.

 I plan to grab the Intel Arc Pro B50 for my server to provide GPU Passthru Windows.

 I'm still kinda lazy in updating READMEs, I will try though.

## Notes on Quickshell (and ricing in a way)

I am slowly moving from Rose Pine themes to Dracula theme due to the more purple accents
matching Vivian's theme.

Quickshell has been slow, but is making a bit of progress, widgets will be build as I go.

Planned color themes:
- Dracula Theme (Dark theme only)
- Nahida Colors (Light theme only)
- JSON Color maker by detecting wallpaper (idea taken from rex's implementation)

# Greenery

Dell Optiplex 7050 that formerly was used as the primary exit-node to evade website blocks by my workplace.

Hosts Suwayomi for reading manga, Jellyfin for music (for now), and Davis for Calendar and Contacts syncing.

Implemented self-hosted websites using Caddy-Tailscale plugin and reverse-proxying localhost ports.

SSH services for file transfer and remote access. Enables sharing my 12TB hard drive (taildrive).

Hooked up to a modded Netgear NAS with TinyCore Linux and Raided HDDs that combine to 14TB. Used primarily for
backups.

Future Endeavors: More functional Jellyfin, FileBrowser for non-nix systems, add discrete GPU for GPU-Passthru Windows
for AI, CAD, and Rendering via remote access, Proxy websites that do not involve with Kaolin (DMV would be confused by me 
being in Zurich), Improve Security as Greenery plays an important role in my self-hosted lifestyle.

# Kaolin

VPS that routes all traffic via Tailscale Exit-node while using wireguard as a bridge to connect tailscale
with Cloudflare-WARP.

Infected Debian with NixOS my beloved.

I would love to use Oracle, but they keep refusing to give me an account.

The ideal of 100% declarative system means the majority of time spent on transferring VPS is the NixOS-infect process.

Future Endeavors: Transition to Oracle (or other sources by November).

# Beryl

ASUSTek Zenbook S13 OLED formerly used for college, now is my plaything for managing nix configs whenever I'm not at home.

Problems: AMDGPU crash prevelent in mainly hardware-accelerated scenarios. Was also observed when Windows was installed.
Due to the issue being a relatively rare scenario (once every month or two), I'm not in a hurry to fix it.

Future Endeavors: Rice my laptop with quickshell and other theming applications, fix AMDGPU crashes from Youtube/demanding HWAccel Tasks.

## Enabling USB4 on Zenbook S13 OLED (UM5302TA)
This is not recommended for most users as it involves "hacking" the
BIOS. DO IT AT YOUR OWN RISK.

UM5302TA is one of the few laptops capable of USB4, but disabled by the
manufacturer due to potential instability with specific devices. 
Despite knowing the risk, I've decided to enable USB4 using 
[UniversalAMDFormBrowser](https://github.com/DavidS95/Smokeless_UMAF/blob/main/UniversalAMDFormBrowser.zip) by following this reddit [post](https://www.reddit.com/r/ASUS/comments/13omq1e/zenbook_s13_bios_update_for_usb_4_whats_going_on/).
Note that there are three options when enabling USB4.

To activate USB4 on NixOS, set ```services.hardware.bolt.enable``` to true.
Test your USB4 ports using boltctl, if there's instability, disable bolt service.

# Graphite

Dell Latitude 5400 found in the dumpster. Consisted of 16GB of RAM and 256GB NVME SSD. Pretty good find imo.

Used for work and ssh into other NixOS systems during work. (Don't tell my manager about the latter)

# Quartz

Custom-built gaming pc intended for workstation and gaming.

Intended to be used as my nix config manager while I'm at home.

Future Endeavors: Implement remote desktop for Beryl/Graphite to communicate. 

## Quartz PC Specifications
- CPU: [Intel i9-12900K non-oxidizing edition](https://www.intel.com/content/www/us/en/products/sku/134599/intel-core-i912900k-processor-30m-cache-up-to-5-20-ghz/specifications.html)
- RAM: [GSkill Ripjaws S5 32GB DDR5-6000](https://www.gskill.com/products/1/165/377/Ripjaws-S5-DDR5-Intel-XMP) (Underclocked to 5600MHz due to RAM stability issues)
- MB: [Gigabyte Z690 AORUS ELITE AX REV 1.4](https://www.gigabyte.com/Motherboard/Z690-AORUS-ELITE-AX-rev-14)
- GPU: [XFX SPEEDSTER MERC 319 AMD RX 6950 XT](https://www.xfxforce.com/shop/xfx-speedster-merc-319-amd-radeon-tm-rx-6950-xt-black)

## Credits
[Rexcrazy804](https://github.com/Rexcrazy804) for literally carrying me. HE NEEDS A JOB AND A BETTER PC.
He also gets a lot of credit for all the code I've stolen with permission.

[Florida Man](https://github.com/zhuazhuzz) for his frontend expertise and helping me mald over quickshell design.

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
- [xcursor-genshin-nahida](https://aur.archlinux.org/packages/xcursor-samtoki-genshin-impact) & [Firefly](https://www.pling.com/p/2226124)
- [User Profile Picture (Nix & Git)](https://danbooru.donmai.us/posts/9246148)
- [Dell Optiplex 3050 Tower Specifications and Image](https://i.dell.com/sites/doccontent/shared-content/data-sheets/en/Documents/OptiPlex-3050-Towers-Technical-Specifications.pdf)
- [Rex's Kokomi Image I shamelessly removed for professionalism](https://danbooru.donmai.us/posts/9590836)
- [Vivian Banshee Wallpaper](https://danbooru.donmai.us/posts/9259057?q=vivian_banshee+pyogo)
- [ASUSTek Zenbook S13 OLED, ASUS removed the website :(](https://www.bestbuy.com/site/asus-zenbook-s-13-oled-um5302-13-3-laptop-amd-ryzen-7-16-gb-memory-1-tb-ssd-ponder-blue/6510809.p)
