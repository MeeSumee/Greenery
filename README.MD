# My NixOS Repository
Consists of Greenery, Beryl, Quartz and Kaolin

## What mess have I created?
 I've been involved in more self-hosted applications, namely suwayomi, jellyfin, and davis with their own
 tailscale IP configured using Caddy-Tailscale plugin.

 Kaolin is a hard-earned success after a week of understanding how to route tailscale traffic via Cloudflare-WARP
 all in the name of avoiding geoblocking. However I'm still stuck with Google Cloud and the trial will end. Need Oracle ASAP.

 Agenix has been implemented successfully in Greenery and forging the path towards a more declarative operating system.

 I've made the quickshell branch and making steady progress towards "banshell" (name subject to change).

 I'm still kinda lazy in updating READMEs, I will try though.

## Notes on Quickshell

Given the shenanigans of first world countries being invasive over the internet, Kaolin took a large part of what
could've been UI design with Quickshell. I will discuss with friends on discord on whether "banshell" shall remain
the name of my quickshell config.

The preliminary colors are based on Rose-Pine theme, however I also plan to implenent themes of:

- Vivian Banshee Colors
- Nahida Colors
- Matugen Color Generation for wallpaper analysis (may replace Vivian Banshee)

# Greenery

Dell Optiplex 3050 that formerly was used as the primary exit-node to evade website blocks by my workplace.

Hosts Suwayomi for reading manga, Jellyfin for music (for now), and Davis for Calendar and Contacts syncing.

Implemented self-hosted websites using Caddy-Tailscale plugin and reverse-proxying localhost ports.

SSH services for file transfer and remote access. Enables sharing my 12TB hard drive (taildrive).

Future Endeavors: More functional Jellyfin, FileBrowser for non-nix systems, 2FAuth so I can stop pulling out my
phone, Proxy websites that do not involve with Kaolin (DMV would be confused by me being in Zurich), Improve 
Security as Greenery plays an important role in my self-hosted lifestyle.

# Kaolin

VPS that routes all traffic via Tailscale Exit-node while using wireguard as a bridge to connect tailscale
with Cloudflare-WARP.

Infected Debian with NixOS my beloved.

As I transition the server into Oracle, the architecture would change from x86-64 to aarch64.

The ideal of 100% declarative system means the majority of time spent on transferring VPS is the NixOS-infect process.

Future Endeavors: Transition to Oracle, utilize Agenix for a declarative system.

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

Copium, but it could be my work laptop if I can argue with IT for installing NixOS on it.

This name will be reserved until I get NixOS on a work laptop.

# Quartz

Custom-built gaming pc intended for workstation and gaming.

Intended to be used as my nix config manager while I'm at home.

Problems: Hyprland 0.50 might have caused genshin to freeze entire system? Noted from btop++ where the GPUs kept switching while playing the game.
Annoying thing is I can't diagnose the problem as journalctl has no leads to the problem. Experimentation imminent.

Future Endeavors: Identify the core issues of dual-gpu setup in NixOS and resolve it, implement remote desktop for Beryl to communicate to, potential GPU-Passthrough Windows. 

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
