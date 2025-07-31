{
  pkgs,
  sources,
  config,
  users,
  lib,
  ...
}: let
  uwuToHypr = pkgs.runCommandLocal "quick" {} ''
    awk '/^export/ { split($2, ARR, "="); print "env = "ARR[1]","ARR[2]}' ${../../dots/uwsm/env} > $out
  '';

  # Set wallpaper
  gothic_lolita_stalker = pkgs.fetchurl {
    name = "gothiclolitadm";
    url = "https://img4.gelbooru.com/images/62/f3/62f3da5821dab06f98cfaf71dc304243.png";
    hash = "sha256-X6zdZVYi6iyGc1M065lNlcqMBVQ21RMX2IKOGAzkzqE=";
  };

  zaphkiel = import sources.zaphkiel {
    inherit (sources) nixpkgs;
  };
in {
  imports = [zaphkiel.nixosModules.kurukuruDM];

  options.greenery.desktop.kurukurudm.enable = lib.mkEnableOption "rex's desktop manager";

  config = lib.mkIf (config.greenery.desktop.kurukurudm.enable && config.greenery.desktop.enable) {

    # Add npins-show command for convenience
    environment.systemPackages = with pkgs; [
      zaphkiel.packages.scripts.npins-show
      kurukurubar-unstable
    ];

    # More rexware, main imports from nixpkgs.nix
    programs.kurukuruDM = {
      enable = true;

      settings = {
        wallpaper = gothic_lolita_stalker;
        default_user = builtins.elemAt users 0;
        instantAuth = false;
        extraConfig = ''
          monitor = DP-1, 3840x2160, 1920x0, 2
          monitor = DP-2, 1920x1080, 0x0, 1
          # night light
          exec-once = wlsunset -T 3000 -t 2999
          source = ${uwuToHypr}
        '';
      };
    };
  };
}

