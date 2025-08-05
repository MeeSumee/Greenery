# My NixOS Repository
Consists of Greenery, Beryl, and Quartz

## Overview
### Repository tree

```
.
├── assets
│   ├── 129992739_p0.jpg
│   ├── 71sMeJBJRNL.png
│   ├── dlcdnwebimgs.asus.png
│   ├── ForRex.jpg
│   └── GDM.png
├── default.nix
├── dots
│   ├── cursors
│   ├── fish
│   │   ├── config.fish
│   │   └── themes
│   │       └── rosepine.theme
│   ├── foot
│   │   └── foot.ini
│   ├── fuzzel
│   │   └── fuzzel.ini
│   ├── hyprland
│   │   ├── hypridle.conf
│   │   ├── hyprland.conf
│   │   └── hyprlock.conf
│   ├── librewolf
│   │   └── librewolf.overrides.cfg
│   ├── micro
│   │   ├── bindings.json
│   │   ├── colorschemes
│   │   │   ├── atom-glass.micro
│   │   │   └── kinetic.micro
│   │   └── settings.json
│   ├── mpv
│   │   └── mpv.conf
│   ├── niri
│   │   └── config.kdl
│   ├── uwsm
│   │   └── env
│   └── yazi
│       └── init.lua
├── flake.lock
├── flake.nix
├── hosts
│   ├── beryl
│   │   ├── battery.nix
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── greenery
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── kaolin
│   │   └── configuration.nix
│   └── quartz
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── LICENSE
├── modules
│   ├── default.nix
│   ├── desktop
│   │   ├── default.nix
│   │   ├── gdm.nix
│   │   ├── gnome.nix
│   │   ├── hypridle.nix
│   │   ├── hyprland.nix
│   │   ├── hyprlock.nix
│   │   ├── kurukurudm.nix
│   │   ├── niri.nix
│   │   ├── sddm.nix
│   │   └── xserver.nix
│   ├── hardware
│   │   ├── amdgpu.nix
│   │   ├── audio.nix
│   │   ├── default.nix
│   │   └── intelgpu.nix
│   ├── networking
│   │   ├── bluetooth.nix
│   │   ├── default.nix
│   │   ├── dnscrypt.nix
│   │   ├── fail2ban.nix
│   │   ├── openssh.nix
│   │   ├── taildrive.nix
│   │   └── tailscale.nix
│   ├── programs
│   │   ├── aagl.nix
│   │   ├── browser.nix
│   │   ├── default.nix
│   │   ├── foot.nix
│   │   ├── micro.nix
│   │   ├── nixpkgs.nix
│   │   ├── nvim.nix
│   │   ├── steam.nix
│   │   └── yazi.nix
│   ├── server
│   │   ├── default.nix
│   │   ├── jellyfin.nix
│   │   ├── minecraft
│   │   │   ├── _backupservice.nix
│   │   │   ├── _default.nix
│   │   │   └── _hollyj.nix
│   │   ├── nix-fabric-minecraft
│   │   │   ├── _configuration.nix
│   │   │   └── _default.nix
│   │   └── suwayomi.nix
│   └── system
│       ├── default.nix
│       ├── fish.nix
│       ├── fonts.nix
│       ├── input.nix
│       ├── lanzaboote.nix
│       ├── locale.nix
│       └── nix.nix
├── npins
│   ├── default.nix
│   └── sources.json
├── pkgs
│   └── cursors.nix
└── README.MD
```
Commit: 94048b0

## What mess have I created?
 I've fully moved away from flakes and instead use npins to mimic flakes.

 I've made the quickshell branch and making steady progress towards "banshell" (name subject to change).

 I've ditched sddm, explored greetd, got frustrated, then returned back to gdm and tried to poke at the source file to theme it.
 Then ditched gdm for Rexcrazy's own display manager, dubbed kurukuruDM.

 Trying to get even more self-hosted websites in my tainet. Only problem is the lack of subdomains unless I try to containerize them.
 I have the potential option of making reverse proxy nodes, but need to have a concrete plan setup before executing.

 Hopefully start Kaolin to evade certain "restrictions". I'm still waiting for the email Oracle...

 Implement agenix and made the system a bit more declarative rather than linking password files to a hard-coded path.

 I've gotten lazy in writing READMEs so anyone can open a PR on updating or formatting the README to look pretty.

# Greenery

Used as exit node to evade work WiFi website blocks and other annoying things
IT throws at me.

Enables me to read manga anywhere at anytime thanks to suwayomi and the use of tailscale serve.

SSH services for file transfer and remote access. Enables sharing my 12TB hard drive (taildrive).

Future Endeavors: Jellyfin for anime hosting and music (maybe fetch youtube and spotify?), Nextcloud for file transfer and calendar syncing with my quickshell endeavor. 

# Beryl

ASUSTek Zenbook S13 OLED formerly used for college, now is my plaything for managing nix configs whenever I'm not at home.

Future Endeavors: Remote into quartz for gaming on the go or using workstation-based applications.

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

# Quartz

Custom-built gaming pc intended for workstation and gaming.

Intended to be used as my nix config manager while I'm at home.

Future Endeavors: Remote desktop setup for devices in my tailnet to access, GPU-Passthrough Windows? Honestly not too sure if I need it.

## Quartz PC Specifications
- CPU: [Intel i9-12900K non-oxidizing edition](https://www.intel.com/content/www/us/en/products/sku/134599/intel-core-i912900k-processor-30m-cache-up-to-5-20-ghz/specifications.html)
- RAM: [GSkill Ripjaws S5 32GB DDR5-6000](https://www.gskill.com/products/1/165/377/Ripjaws-S5-DDR5-Intel-XMP) (Underclocked to 5600MHz due to RAM stability issues)
- MB: [Gigabyte Z690 AORUS ELITE AX REV 1.4](https://www.gigabyte.com/Motherboard/Z690-AORUS-ELITE-AX-rev-14)
- GPU: [XFX SPEEDSTER MERC 319 AMD RX 6950 XT](https://www.xfxforce.com/shop/xfx-speedster-merc-319-amd-radeon-tm-rx-6950-xt-black)

## Credits
[Rexcrazy804](https://github.com/Rexcrazy804) for literally carrying me. I swear he needs a better PC.
He also gets a lot of credit for all the code I've stolen with permission.

[Z](https://github.com/zhuazhuzz) for his frontend expertise and helping me mald over quickshell design.

Several sources of quickshell code I've been browsing through in an attempt to understand wtf is going on:
[Outfoxxed](https://quickshell.outfoxxed.me/), [Soramane](https://github.com/caelestia-dots/shell), [Ly-sec](https://github.com/Ly-sec/nixos), [end_4 (Hi for swapped.txt)](https://github.com/end-4/dots-hyprland), [Rexcrazy804 (Hai~)](https://github.com/Rexcrazy804/Zaphkiel/tree/master/users/dots/quickshell/kurukurubar), [bbedward](https://github.com/bbedward/DankMaterialShell)

I also want to thank the folks of UAFB who made USB4 possible.

Lastly, I want to thank the Nix Community for its push for packages,
maintainers, and hardware support. I haven't had this much fun in
a while. Especially for coding cause I never get As in coding class.

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
