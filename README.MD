# Beryl
My Personal Laptop, an ASUS Zenbook S13 OLED (UM5302)
![image](https://github.com/MeeSumee/Beryl/blob/507d56ffd8bc8dbb229f64353ea4c032a792f9e4/beryl/src/dlcdnwebimgs.asus.png)
- Source : [ASUS](https://www.asus.com/us/laptops/for-home/zenbook/zenbook-s-13-oled-um5302/)

## NixOS Configuration
![image](https://github.com/MeeSumee/Beryl/blob/b5b12e39d878a493e417e0596055fe8849065894/beryl/src/Screenshot%20From%202025-05-16%2013-14-41.png)
- Wallpaper : [Vivian Banshee by pyogo (danbooru)](https://danbooru.donmai.us/posts/9259057)

## Introduction
So, I've started doing Nix Shenanigans, how did I get here and what did I do?

Well, RexCrazy804 invited me to this bandwagon because my laptop has started 
to crash more often thanks to Microsoft™ Windows 11. Due to increased 
frustration and wanting a config I can pull from quite easily for each laptop 
generation I get, NixOS seemed to tick a lot of boxes. Of course, without Rex, 
I will not get this far this quickly as the NixOS learning curve is steep, 
especially for me who has not used Linux often and only experimented with 
distros of Debian when I was not even a teenager.

The NixOS learning curve started by experimenting it in VMware. In this way I
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
drivers. Refer to [configuration.nix](https://github.com/MeeSumee/Beryl/blob/b5b12e39d878a493e417e0596055fe8849065894/beryl/hosts/Sumeezome/configuration.nix) as for how I implemented it.
Remember to swipe on the fingerprint sensor rather than the usual tap.
(I swear it took me so long to realize this)

## Lanzaboote
This is strictly a Work-In-Progress section.

It mostly involved following instructions [here](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md)
However, I have not tested Lanzaboote with BIOS password enabled.

## Japanese Keyboard IME ( 日本語 )
This can be used by anyone with a keyboard. Refer [here](https://search.nixos.org/options?channel=24.11&show=i18n.supportedLocales&size=50&sort=relevance&type=packages&query=i18n) for more details.

## MATLAB
This is strictly a Work-In-Progress section.

MATLAB is a pain since it can't be packaged easily due to licensing.
MATLAB does have an online option for a valid account, therefore I
was not too worried if it failed.
Most instructions were followed [here](https://gitlab.com/doronbehar/nix-matlab)

## Enabling USB4
This is not recommended for most users as it involves "hacking" the
BIOS. DO IT AT YOUR OWN RISK.

UM5302TA is one of the few laptops capable of USB4, but disabled by the
manufacturer due to potential instability with specific devices. 
Despite knowing the risk, I've decided to enable USB4 using 
[UniversalAMDFormBrowser](https://github.com/DavidS95/Smokeless_UMAF/blob/main/UniversalAMDFormBrowser.zip) by following this reddit [post](https://www.reddit.com/r/ASUS/comments/13omq1e/zenbook_s13_bios_update_for_usb_4_whats_going_on/)
Note that there are three options when enabling USB4.

To activate USB4 on NixOS, enable the bolt service from my config.
Test your USB4 ports using boltctl, if there's instability, disable.

## What's left in hardware & software
There is no easy way to toggle the webcam using Fn + F10 (Fn Lock enabled)
It involves running a custom script/program which I've yet to bother.

System is currently in HSI:1 security and needs a few security tweaks.

I have no idea whether Pixel Shift (OLED Care) works in NixOS. I got a
[Pixel Shift Test image](https://github.com/MeeSumee/Beryl/blob/b5b12e39d878a493e417e0596055fe8849065894/beryl/src/PIXELSHIFTTEST.png), however, I cannot notice any pixel shifts.

I will try to get this config into a VM like umbrella for anyone to
test it out or make any changes. 

## Credits
[RexCrazy804](https://github.com/Rexcrazy804) for literally carrying me. I swear he needs a better PC.

![image](https://github.com/MeeSumee/Beryl/blob/ba8149adbae3132c239b42b6fda52fbd54f66713/beryl/src/ForRex.jpg)

This is for you Rex, as a token of gratitude.
(It does not exist in danbooru for some reason) 

I also want to thank the folks of UAFB who made USB4 possible.

Lastly, I want to thank the Nix Community for its push for packages,
maintainers, and hardware support. I haven't had this much fun in
a while. Especially for coding cause I never get As in coding class.

## Licensing
All code in this repository is under the MIT license unless wherever an
explicit licensing is included.

## Miscellaneous Sources
- [User Profile Picture (Nix & Git)](https://danbooru.donmai.us/posts/9246148)
