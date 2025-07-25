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
│   │   ├── Firefly
│   │   │   ├── cursors
│   │   │   │   ├── all-scroll
│   │   │   │   ├── arrow
│   │   │   │   ├── bottom_left_corner
│   │   │   │   ├── bottom_right_corner
│   │   │   │   ├── bottom_side
│   │   │   │   ├── circle
│   │   │   │   ├── closedhand
│   │   │   │   ├── col-resize
│   │   │   │   ├── cross
│   │   │   │   ├── crossed_circle
│   │   │   │   ├── crosshair
│   │   │   │   ├── default
│   │   │   │   ├── dnd-move
│   │   │   │   ├── dnd_no_drop
│   │   │   │   ├── dnd-none
│   │   │   │   ├── down-arrow
│   │   │   │   ├── draft
│   │   │   │   ├── e-resize
│   │   │   │   ├── ew-resize
│   │   │   │   ├── fleur
│   │   │   │   ├── forbidden
│   │   │   │   ├── grab
│   │   │   │   ├── grabbing
│   │   │   │   ├── half-busy
│   │   │   │   ├── hand
│   │   │   │   ├── hand1
│   │   │   │   ├── hand2
│   │   │   │   ├── h_double_arrow
│   │   │   │   ├── help
│   │   │   │   ├── ibeam
│   │   │   │   ├── left-arrow
│   │   │   │   ├── left_ptr
│   │   │   │   ├── left_ptr_help
│   │   │   │   ├── left_ptr_watch
│   │   │   │   ├── left_side
│   │   │   │   ├── move
│   │   │   │   ├── ne-resize
│   │   │   │   ├── nesw-resize
│   │   │   │   ├── no_drop
│   │   │   │   ├── not_allowed
│   │   │   │   ├── n-resize
│   │   │   │   ├── ns-resize
│   │   │   │   ├── nw-resize
│   │   │   │   ├── nwse-resize
│   │   │   │   ├── openhand
│   │   │   │   ├── pencil
│   │   │   │   ├── pirate
│   │   │   │   ├── pointer
│   │   │   │   ├── pointing_hand
│   │   │   │   ├── progress
│   │   │   │   ├── question_arrow
│   │   │   │   ├── right-arrow
│   │   │   │   ├── right_side
│   │   │   │   ├── row-resize
│   │   │   │   ├── sb_h_double_arrow
│   │   │   │   ├── sb_v_double_arrow
│   │   │   │   ├── se-resize
│   │   │   │   ├── size_all
│   │   │   │   ├── size-bdiag
│   │   │   │   ├── size_bdiag
│   │   │   │   ├── size-fdiag
│   │   │   │   ├── size_fdiag
│   │   │   │   ├── size-hor
│   │   │   │   ├── size_hor
│   │   │   │   ├── size-ver
│   │   │   │   ├── size_ver
│   │   │   │   ├── split_h
│   │   │   │   ├── split_v
│   │   │   │   ├── s-resize
│   │   │   │   ├── sw-resize
│   │   │   │   ├── text
│   │   │   │   ├── top_left_arrow
│   │   │   │   ├── top_left_corner
│   │   │   │   ├── top_right_corner
│   │   │   │   ├── top_side
│   │   │   │   ├── up_arrow
│   │   │   │   ├── v_double_arrow
│   │   │   │   ├── wait
│   │   │   │   ├── watch
│   │   │   │   ├── whats_this
│   │   │   │   ├── w-resize
│   │   │   │   └── xterm
│   │   │   ├── index.theme
│   │   │   └── preview.gif
│   │   └── xcursor-genshin-nahida
│   │       ├── cursors
│   │       │   ├── alias
│   │       │   ├── all-scroll -> fleur
│   │       │   ├── arrow -> left_ptr
│   │       │   ├── bottom_left_corner
│   │       │   ├── bottom_right_corner
│   │       │   ├── bottom_side
│   │       │   ├── cell
│   │       │   ├── center_ptr
│   │       │   ├── circle -> not-allowed
│   │       │   ├── closedhand -> openhand
│   │       │   ├── color-picker
│   │       │   ├── col-resize
│   │       │   ├── context-menu
│   │       │   ├── copy
│   │       │   ├── cross -> crosshair
│   │       │   ├── crossed_circle -> not-allowed
│   │       │   ├── crosshair
│   │       │   ├── default
│   │       │   ├── dnd-copy -> copy
│   │       │   ├── dnd-move
│   │       │   ├── dnd-no-drop
│   │       │   ├── dnd-none -> dnd-move
│   │       │   ├── down-arrow
│   │       │   ├── draft
│   │       │   ├── e-resize -> size_hor
│   │       │   ├── ew-resize -> size_hor
│   │       │   ├── fleur
│   │       │   ├── forbidden -> no-drop
│   │       │   ├── grab -> openhand
│   │       │   ├── grabbing -> closedhand
│   │       │   ├── half-busy -> progress
│   │       │   ├── hand1 -> pointer
│   │       │   ├── hand2 -> pointer
│   │       │   ├── h_double_arrow -> size_hor
│   │       │   ├── help
│   │       │   ├── ibeam
│   │       │   ├── left-arrow
│   │       │   ├── left_ptr -> default
│   │       │   ├── left_ptr_help -> help
│   │       │   ├── left_ptr_watch -> progress
│   │       │   ├── left_side
│   │       │   ├── link -> alias
│   │       │   ├── move -> dnd-move
│   │       │   ├── ne-resize -> size_bdiag
│   │       │   ├── nesw-resize -> size_bdiag
│   │       │   ├── no-drop
│   │       │   ├── not-allowed
│   │       │   ├── n-resize -> size_ver
│   │       │   ├── ns-resize -> size_ver
│   │       │   ├── nw-resize -> size_fdiag
│   │       │   ├── nwse-resize -> size_fdiag
│   │       │   ├── openhand
│   │       │   ├── pencil
│   │       │   ├── pirate
│   │       │   ├── plus -> cell
│   │       │   ├── pointer -> crosshair
│   │       │   ├── pointing_hand -> pointer
│   │       │   ├── progress
│   │       │   ├── question_arrow -> help
│   │       │   ├── right-arrow
│   │       │   ├── right_ptr
│   │       │   ├── right_side
│   │       │   ├── row-resize
│   │       │   ├── sb_h_double_arrow -> size_hor
│   │       │   ├── sb_v_double_arrow -> size_ver
│   │       │   ├── se-resize -> size_fdiag
│   │       │   ├── size_all -> fleur
│   │       │   ├── size-bdiag -> default
│   │       │   ├── size_bdiag
│   │       │   ├── size-fdiag -> default
│   │       │   ├── size_fdiag
│   │       │   ├── size-hor -> default
│   │       │   ├── size_hor
│   │       │   ├── size-ver -> default
│   │       │   ├── size_ver
│   │       │   ├── split_h -> col-resize
│   │       │   ├── split_v -> row-resize
│   │       │   ├── s-resize -> size_ver
│   │       │   ├── sw-resize -> size_bdiag
│   │       │   ├── tcross -> crosshair
│   │       │   ├── text
│   │       │   ├── top_left_arrow -> default
│   │       │   ├── top_left_corner
│   │       │   ├── top_right_corner
│   │       │   ├── top_side
│   │       │   ├── up-arrow
│   │       │   ├── v_double_arrow -> size_ver
│   │       │   ├── vertical-text
│   │       │   ├── wait
│   │       │   ├── watch -> wait
│   │       │   ├── wayland-cursor
│   │       │   ├── whats_this -> help
│   │       │   ├── w-resize -> size_hor
│   │       │   ├── x-cursor
│   │       │   ├── xterm -> ibeam
│   │       │   ├── zoom-in
│   │       │   └── zoom-out
│   │       └── index.theme
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
│   ├── quickshell
│   │   ├── Assets
│   │   │   ├── nahidah.gif
│   │   │   ├── nahidas.gif
│   │   │   ├── NixOS.png
│   │   │   ├── volumemute.svg
│   │   │   └── volume.svg
│   │   ├── Corners.txt
│   │   ├── Data
│   │   │   └── Colors.qml
│   │   ├── Panels
│   │   │   ├── Bar.qml
│   │   │   └── Volume.qml
│   │   ├── Properties
│   │   │   └── Globals.qml
│   │   ├── shell.qml
│   │   └── Widgets
│   │       ├── Battery.qml
│   │       ├── ClockWidget.qml
│   │       ├── Logo.qml
│   │       └── Time.qml
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
│   ├── quartz
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── vmmaker
│       ├── beryl.nix
│       └── quartz.nix
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
│   │   ├── manga.nix
│   │   ├── minecraft
│   │   │   ├── backupservice.archivenix
│   │   │   ├── default.archivenix
│   │   │   └── hollyj.archivenix
│   │   └── nix-fabric-minecraft
│   │       ├── configuration.archivenix
│   │       └── default.archivenix
│   └── system
│       ├── default.nix
│       ├── fish.nix
│       ├── fonts.nix
│       ├── input.nix
│       ├── lanzaboote.nix
│       ├── locale.nix
│       ├── nix.nix
│       └── sops.nix
├── npins
│   ├── default.nix
│   └── sources.json
├── pkgs
│   └── cursors.nix
└── README.MD
```
Commit: d49d2fc

## What mess have I created?
 I've fully moved away from flakes and instead use npins to mimic flakes.

 I'm setting up both Niri and Hyprland at the same time for two different systems (Crazy).
 Plan is to have Niri on my laptop with quickshell optimized for performance and Hyprland on my desktop with
 lots of features.

 I've ditched sddm, explored greetd, got frustrated, then returned back to gdm and tried to poke at the source file to theme it.
 Then ditched gdm for Rexcrazy's own display manager, dubbed kurukuruDM.

 I've gotten lazy in writing READMEs so anyone can open a PR on updating or formatting the README to look pretty.

# Greenery

## Overview
Used as exit node to evade work WiFi website blocks and other annoying things
IT throws at me.

Enables me to read manga anywhere at anytime thanks to suwayomi and tailscale reverse-proxy.

SSH services for file transfer and remote access. Enables sharing my 12TB hard drive (taildrive).

Future Endeavors: Jellyfin for anime hosting, maybe implement nextcloud services. 

# Beryl

## Overview
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

## Quartz PC Specifications
- CPU: [Intel i9-12900K non-oxidizing edition](https://www.intel.com/content/www/us/en/products/sku/134599/intel-core-i912900k-processor-30m-cache-up-to-5-20-ghz/specifications.html)
- RAM: [GSkill Ripjaws S5 32GB DDR5-6000](https://www.gskill.com/products/1/165/377/Ripjaws-S5-DDR5-Intel-XMP) (Underclocked to 5600MHz due to RAM stability issues)
- MB: [Gigabyte Z690 AORUS ELITE AX REV 1.4](https://www.gigabyte.com/Motherboard/Z690-AORUS-ELITE-AX-rev-14)
- GPU: [XFX SPEEDSTER MERC 319 AMD RX 6950 XT](https://www.xfxforce.com/shop/xfx-speedster-merc-319-amd-radeon-tm-rx-6950-xt-black)

## Overview

Custom-built gaming pc intended for workstation and gaming.

Intended to be used as my nix config manager while I'm at home.

Future Endeavors: Remote desktop setup for devices in my tailnet to access, GPU-Passthrough Windows for Altium Designer or other niche high performance demanding applications.

## Credits
[Rexcrazy804](https://github.com/Rexcrazy804) for literally carrying me. I swear he needs a better PC.
He also gets a lot of credit for all the code I've stolen with permission.

[Z](https://github.com/zhuazhuzz) for his frontend expertise and helping me mald over quickshell design.

Several sources of quickshell code I've been browsing through in an attempt to understand wtf is going on:
[Outfoxxed](https://quickshell.outfoxxed.me/), [Soramane](https://github.com/caelestia-dots/shell), [Ly-sec](https://github.com/Ly-sec/nixos), [end_4 (Hi for swapped.txt)](https://github.com/end-4/dots-hyprland), [Rexcrazy804 (Hai~)](https://github.com/Rexcrazy804/Zaphkiel/tree/master/users/dots/quickshell/kurukurubar)  

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
