# My NixOS Repository
Consists of Greenery, Beryl, and Quartz

## Overview
> Structure of the repository

assets/                      # Miscellaneous pictures, gifs, sources used in this repo
dots/                        # Welcome to the ricefields, fellow ricers! Most are imported using hjem
- cursors/                   # Cursors imported from [AUR](https://aur.archlinux.org/packages/xcursor-samtoki-genshin-impact) and [Pling](https://www.pling.com/p/2226124), imported using cursors.nix in pkgs/
- fish/                      # [Fish](https://fishshell.com/) Shell ini and its themes
- foot/                      # [Foot](https://codeberg.org/dnkl/foot) terminal ini
- fuzzel/                    # [Fuzzel](https://codeberg.org/dnkl/fuzzel) app launcher ini
- hyprland/                  # [Hyprland](https://hypr.land/) and [Hypridle](https://github.com/hyprwm/hypridle) configuration
- librewolf/                 # Attempted [librewolf](https://librewolf.net/) configuration override, didn't override my config as of late
- niri/                      # [Niri](https://github.com/YaLTeR/niri) configuration
- quickshell/                # [Quickshell](https://quickshell.outfoxxed.me/) configuration. WIP in quickshell-test branch
- uwsm/                      # [UWSM](https://github.com/Vladimir-csp/uwsm) environment variables.
hosts/                       # Consists of all my devices and their configurations
- beryl/                     # ASUSTek Zenbook S13 OLED (UM5302TA) Laptop. WM = Niri
- greenery/                  # Dell Optiplex 3050 Tower Server. WM = None. SSH Only!
- quartz/                    # Personal Gaming PC with i9-12900K and RX 6950XT. WM = Hyprland
- vmmaker/                   # QEMU VM "initializers" when you build my configuration using ```nix run```
modules/                     # Key elements for all of my devices
- common/                    # Common elements shared across all of my devices
- gui/                       # Elements shared by devices that consists of a GUI (ex. Beryl & Quartz)
- server/                    # Random minecraft/jellyfin server config added before this repository merged. WIP
npins/                       # Auto-generated config when using npins command. Take note that it gets rewritten when modifying npins
pkgs/                        # Consists of cursors.nix, fetches my repository dots and packages it as a nix package
flake.nix                    # Unified flake that governs all of the inputs, and outputs of my devices. Slowly transitioning to npins

### Running my configuration by building a VM locally
To test out or modify either of my NixOS configurations, run the following commands on your desired folder:

Greenery (GVM):
```
nix run github:MeeSumee/Greenery#nixosConfigurations.GVM.config.system.build.vm
```
Username: ```greenery```

Initial Password: ```touchgrass```

Beryl (BVM):
```
nix run github:MeeSumee/Greenery#nixosConfigurations.BVM.config.system.build.vm
```
Initial Password: ```berylline```

Notes: Beryl VM (BVM) crashes in my own laptop using Niri. This could be a Rembrandt GPU issue.

## What mess have I created?
> Whilst juggling many things at once, (Niri, Quickshell, Hyprland, new desktop config, Silent-SDDM, and many more...),
> I never bothered to update the README until this commit. 

> I've made a new branch called quickshell-test where I "try" to mess around and get a quickshell bar working. My plan
> is to implement my bar (currently unnamed) for Niri with Niri Workspace support. I may add Hyprland support if deemed 
> necessary for Quartz.

> I'm transitioning towards npins, however, my repository remains flake dependent. As of right now, I currently use
> npins for non-flake repositories and future nix inputs.

> I'm setting up both Niri and Hyprland at the same time for two different systems (Crazy).
> Plan is to have Niri on my laptop with quickshell optimized for performance and Hyprland on my desktop with
> lots of features.

> I've abandoned MATLAB in favor of it's online version as well as having Octave for offline engineering.

> ASUS Trackpad Numpad does not work with Niri. This can be attributed to the python script being targeted for GNOME environments.

> Silent-SDDM works fine for single monitor and multi-monitor setups with a few caveats.
> For my multiple monitor setup, Silent-SDDM config duplicates the login screen and resets your display arrangement to default settings.
> If you receive a blank white screen with the background only filling a part of the screen due to your monitors consisting of different resolutions,
> add this to your configuration: 
> ```
>     wayland = {
>       enable = true;
>       compositorCommand = "${lib.getExe' pkgs.kdePackages.kwin "kwin_wayland"} --drm --no-lockscreen --no-global-shortcuts --locale1";
>     };
> ```

The rest of the repository are from the legacy README that I didn't bother reformatting.

## Japanese Keyboard IME ( 日本語 )
Insert this into your i18n:
```bash
extraLocales = [ "ja_JP.UTF-8" ];
```
For Japanese Input, add this to your config. Fonts and inputs are customizable.
```bash
  # Font Settings for both English and Japanese
  fonts.packages = with pkgs; [
    carlito
    dejavu_fonts
    ipafont
    kochi-substitute
    source-code-pro
    ttf_bitstream_vera
  ];
  
  # Enable fcitx for Input Method Editor (IME)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };
  
  # Add and enable mozc as input method in fcitx. Good for JP input.
  i18n.inputMethod.fcitx5 = {
    addons = [ pkgs.fcitx5-mozc ];
    
    settings.inputMethod = {
      "Groups/0" = {
        "Name" = "Default";
        "Default Layout" = "us";
        "DefaultIM" = "mozc";
      };
      "Groups/0/Items/0" = {
        "Name" = "keyboard-us";
        "Layout" = null;
      };
      "Groups/0/Items/1" = {
        "Name" = "mozc";
        "Layout" = null;
      };
    };
  };
  
  # Provides ibus for input method
  environment.variables.GLFW_IM_MODULE = "ibus";
```

My JP Keyboard Config can be used by anyone with a keyboard. Refer [here](https://search.nixos.org/options?channel=24.11&show=i18n.supportedLocales&size=50&sort=relevance&type=packages&query=i18n) for options.

## Enabling USB4
This is not recommended for most users as it involves "hacking" the
BIOS. DO IT AT YOUR OWN RISK.

UM5302TA is one of the few laptops capable of USB4, but disabled by the
manufacturer due to potential instability with specific devices. 
Despite knowing the risk, I've decided to enable USB4 using 
[UniversalAMDFormBrowser](https://github.com/DavidS95/Smokeless_UMAF/blob/main/UniversalAMDFormBrowser.zip) by following this reddit [post](https://www.reddit.com/r/ASUS/comments/13omq1e/zenbook_s13_bios_update_for_usb_4_whats_going_on/).
Note that there are three options when enabling USB4.

To activate USB4 on NixOS, set ```services.hardware.bolt.enable``` to true.
Test your USB4 ports using boltctl, if there's instability, disable bolt service.

# Greenery Rambling
This server aims to be completely remote providing only ssh access from the devices I allow.
This server is configured as a minecraft server with the intentions of running either 
vanilla or modded. I've configured it with the intention of supporting all modloaders,
including the infamous Forge. I've already seen Rex complain about forge driving him insane
which means I can't exactly do much about it. I also tried nix-fabric by fetching toml files
using my modpacks repo, but curseforge API keeps requesting me to manually download and
blocks Nix toml fetching from Infinidoge's Nix-minecraft.

Right now, I am running modpacks based on a dedicated folder where I extracted the server_pack
and running it's start batch script while complying to it's Java version. I will figure
out how I can automate the server pack fetching declaratively.

## Tailscale
Tailscale is integral to how the server operates and how I connect my devices.
I've setup Greenery to act as an exit node to route all my traffic so my
workplace doesn't fucking break websites and block me from pushing to git.
I swear IT has been cracking down on what I've been meaning to use.
I've defined on networking.nix as well as configuration.nix on how I've opened up the
Firewall and the tailscale service to utilize MagicDNS routing in Tailscale.
Tailscale enables me to share my server to other users to enable them to
connect to my Minecraft Server. It reduces the risk of attackers trying
to obtain IP addresses as well as bypass the blocked ports from my home
WiFi.

I also use Tailscale as a means to send files between my devices using Taildrop.
This is why I ditched the original method of KDEConnect.

## Credits
[Rexcrazy804](https://github.com/Rexcrazy804) for literally carrying me. I swear he needs a better PC.
He also gets a lot of credit for all the code I've stolen with permission.

[Z](https://github.com/zhuazhuzz) for his frontend expertise and helping me mald over quickshell design.

Several sources of quickshell code I've been browsing through in an attempt to understand wtf is going on:
[Outfoxxed](https://quickshell.outfoxxed.me/), [Soramane](https://github.com/caelestia-dots/shell), [end_4 (Hi for swapped.txt)](https://github.com/end-4/dots-hyprland), [Ly-sec](https://github.com/Ly-sec/nixos), [Rexcrazy804 (Hai~)](https://github.com/Rexcrazy804/Zaphkiel/tree/master/users/dots/quickshell/kurukurubar)  

I also want to thank the folks of UAFB who made USB4 possible.

Lastly, I want to thank the Nix Community for its push for packages,
maintainers, and hardware support. I haven't had this much fun in
a while. Especially for coding cause I never get As in coding class.

## Quartz PC Specifications
Curious? Well, here ya go
- CPU: [Intel i9-12900K non-oxidizing edition](https://www.intel.com/content/www/us/en/products/sku/134599/intel-core-i912900k-processor-30m-cache-up-to-5-20-ghz/specifications.html)
- RAM: [GSkill Ripjaws S5 32GB DDR5-6000](https://www.gskill.com/products/1/165/377/Ripjaws-S5-DDR5-Intel-XMP) (Underclocked to 5600MHz due to RAM stability issues)
- MB: [Gigabyte Z690 AORUS ELITE AX REV 1.4](https://www.gigabyte.com/Motherboard/Z690-AORUS-ELITE-AX-rev-14)
- GPU: [XFX SPEEDSTER MERC 319 AMD RX 6950 XT](https://www.xfxforce.com/shop/xfx-speedster-merc-319-amd-radeon-tm-rx-6950-xt-black)

## Licensing
All code in this repository is under the MIT license unless wherever an
explicit licensing is included.

## Miscellaneous Sources
- [User Profile Picture (Nix & Git)](https://danbooru.donmai.us/posts/9246148)
- [Dell Optiplex 3050 Tower Specifications and Image](https://i.dell.com/sites/doccontent/shared-content/data-sheets/en/Documents/OptiPlex-3050-Towers-Technical-Specifications.pdf)
- [Rex's Kokomi Image I shamelessly removed for professionalism](https://danbooru.donmai.us/posts/9590836)
- [Vivian Banshee Wallpaper](https://danbooru.donmai.us/posts/9259057?q=vivian_banshee+pyogo)
- [ASUSTek Zenbook S13 OLED, ASUS removed the website :(](https://www.bestbuy.com/site/asus-zenbook-s-13-oled-um5302-13-3-laptop-amd-ryzen-7-16-gb-memory-1-tb-ssd-ponder-blue/6510809.p)
