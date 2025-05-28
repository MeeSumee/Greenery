# My NixOS Repository
Consists of Greenery, and Beryl

## Greenery
My server, a Dell Optiplex 3050 Tower
![image](https://github.com/MeeSumee/Greenery/blob/ae043156180a0bac329dac5d40b1eac0d310bba6/src/71sMeJBJRNL.png)
- Source : [Dell](https://www.dell.com/support/product-details/en-us/product/optiplex-3050-desktop/overview)

## Greenery NixOS Configuration
![image](https://github.com/MeeSumee/Greenery/blob/ae043156180a0bac329dac5d40b1eac0d310bba6/src/Screenshot%20From%202025-05-16%2015-30-19.png)
- If you didn't catch on, it's minimal NixOS
- Configuration : [configuration.nix](https://github.com/MeeSumee/Greenery/blob/ae043156180a0bac329dac5d40b1eac0d310bba6/hosts/greenery/configuration.nix)

## Beryl
My Personal Laptop, an ASUS Zenbook S13 OLED (UM5302)
![image](https://github.com/MeeSumee/Greenery/blob/ae043156180a0bac329dac5d40b1eac0d310bba6/src/dlcdnwebimgs.asus.png)
- Source : [ASUS](https://www.asus.com/us/laptops/for-home/zenbook/zenbook-s-13-oled-um5302/)

## Beryl NixOS Configuration
![image](https://github.com/MeeSumee/Greenery/blob/ae043156180a0bac329dac5d40b1eac0d310bba6/src/Screenshot%20From%202025-05-16%2013-14-41.png)
- Wallpaper : [Vivian Banshee by pyogo (danbooru)](https://danbooru.donmai.us/posts/9259057)
- Configuration : [configuration.nix](https://github.com/MeeSumee/Greenery/blob/44d0455a17e05871fb4cd5dc475f32973801a1a5/beryl/hosts/Sumeezome/configuration.nix)

# Running my configuration using nix run
To test out or modify either of my NixOS configurations, run the following commands on your desired folder:

Greenery:
```nix run github:MeeSumee/Greenery#greeneryVM```
Username: greenery
Password: touchgrass

Beryl:
```nix run github:MeeSumee/Greenery#berylVM```
Password: berylline

## Introduction
So, I've started doing Nix Shenanigans, how did I get here and what did I do?

Well, RexCrazy804 invited me to this bandwagon because my laptop has started 
to crash more often thanks to Microsoft™ Windows 11. Due to increased 
frustration and wanting a config I can pull from quite easily for each laptop 
generation I get, NixOS seemed to tick a lot of boxes. Of course, without Rex, 
I will not get this far this quickly as the NixOS learning curve is steep, 
especially for me who has not used Linux often and only experimented with 
distros of Debian when I was not even a teenager.

The NixOS learning curve started by experimenting it in VMware. In that way I
can understand the system and get tutored by Rex easily in one machine. Once
I got to installing it on my laptop, the first major challenge is configuring
the hardware to best utilize my laptop with Nix. Luckily, being an ASUS Laptop,
I can fork the [battery](https://github.com/NixOS/nixos-hardware/blob/master/asus/battery.nix) config straight from Nix-Hardware Repository and
configure how Nix handles my laptop battery by setting charge level etc. To
my surprise, Nix-GNOME automatically configured the Touchscreen as well as my 
[stylus](https://renaisser.com/products/raphael-slim) and works well when tested on Xournal++. It is also surprising how 
the majority of the Fn key shortcuts work out of the box. Despite these going
smoothly, there are a few things I had to do for hardware and software.

## ASUS Trackpad Numpad
It is very easy to configure the trackpad and mainly followed [this](https://github.com/asus-linux-drivers/asus-numberpad-driver)
repository. Just follow NixOS flake config as home-manager is not required
for GNOME as far as I know.

## Fingerprint Sensor
It is also relatively straightforward as all I did is use fprint with ELAN
drivers. Refer to [configuration.nix](https://github.com/MeeSumee/Greenery/blob/ae043156180a0bac329dac5d40b1eac0d310bba6/hosts/beryl/configuration.nix) as for how I implemented it.
Remember to swipe on the fingerprint sensor rather than the usual tap.
(I swear it took me so long to realize this)

## Lanzaboote
This is strictly a Work-In-Progress section.

It mostly involved following instructions [here](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md).
However, I have not tested Lanzaboote with BIOS password enabled.

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
  
  # Enable mozc as input method in fcitx. Good for JP input.
  i18n.inputMethod.fcitx5.addons = [ pkgs.fcitx5-mozc ];
  
  # Provides ibus for input method
  environment.variables.GLFW_IM_MODULE = "ibus";
```

My JP Keyboard Config can be used by anyone with a keyboard. Refer [here](https://search.nixos.org/options?channel=24.11&show=i18n.supportedLocales&size=50&sort=relevance&type=packages&query=i18n) for options.

## MATLAB
This is strictly a Work-In-Progress section.

MATLAB is a pain since it can't be packaged easily due to licensing.
MATLAB does have an online option for a valid account, which means I
was not too worried if it failed.
Most instructions were followed [here](https://gitlab.com/doronbehar/nix-matlab)

As of writing this, MATLAB fails to launch due to the following error reported in console:
```bash
Launching updater executable
An unexpected error has occurred.
To resolve this issue, contact <a href="https://www.mathworks.com/pi_gene_mci_glnxa64">Technical Support</a>"
```

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

## What's left in hardware & software for Beryl
There is no easy way to toggle the webcam using Fn + F10 (Fn Lock enabled).
It involves running a custom script/program which I've yet to bother.

System is currently in HSI:1 security and needs a few security tweaks.

I have no idea whether Pixel Shift (OLED Care) works in NixOS. I got a
[Pixel Shift Test image](https://github.com/MeeSumee/Greenery/blob/ae043156180a0bac329dac5d40b1eac0d310bba6/src/PIXELSHIFTTEST.png), however, I cannot notice any pixel shifts.

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
I've defined on my [config](https://github.com/MeeSumee/Greenery/blob/ae043156180a0bac329dac5d40b1eac0d310bba6/hosts/greenery/configuration.nix) on how I've opened up the
Firewall and the tailscale service to utilize MagicDNS routing in Tailscale.
Tailscale enables me to share my server to other users to enable them to
connect to my Minecraft Server. It reduces the risk of attackers trying
to obtain IP addresses as well as bypass the blocked ports from my home
WiFi.

I also use Tailscale as a means to send files between my devices using Taildrop.
This is why I ditched the original method of KDEConnect.

## Credits
[RexCrazy804](https://github.com/Rexcrazy804) for literally carrying me. I swear he needs a better PC.

![image](https://github.com/MeeSumee/Greenery/blob/ae043156180a0bac329dac5d40b1eac0d310bba6/src/ForRex.jpg)

This is for you Rex, as a token of gratitude.

I also want to thank the folks of UAFB who made USB4 possible.

Lastly, I want to thank the Nix Community for its push for packages,
maintainers, and hardware support. I haven't had this much fun in
a while. Especially for coding cause I never get As in coding class.

## Licensing
All code in this repository is under the MIT license unless wherever an
explicit licensing is included.

## Miscellaneous Sources
- [User Profile Picture (Nix & Git)](https://danbooru.donmai.us/posts/9246148)
