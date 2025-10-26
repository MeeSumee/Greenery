{
  pkgs,
  config,
  users,
  lib,
  inputs,
  ...
}: let
  uwuToHypr = pkgs.runCommandLocal "quick" {} ''
    awk '/^export/ { split($2, ARR, "="); print "env = "ARR[1]","ARR[2]}' ${../../dots/uwsm/env} > $out
  '';

  # Set wallpaper
  listening = pkgs.fetchurl {
    name = "listening";
    url = "https://cdn.donmai.us/original/bb/e8/bbe8f1413839cdacc56b28e05c502d5d.jpg?download=1";
    hash = "sha256-XbrujvmGo90L7EOY5i1ydc3GQi77NJ68mxVHyMMq5gg=";
  };

in {
  imports = [inputs.zaphkiel.nixosModules.kurukuruDM];

  options.greenery.desktop.kurukurudm.enable = lib.mkEnableOption "rex's desktop manager";

  config = lib.mkIf (config.greenery.desktop.kurukurudm.enable && config.greenery.desktop.enable) {

    # Add dependencies
    environment.systemPackages = with pkgs; [
      kurukurubar
    ];

    # More rexware, main imports from nixpkgs.nix
    programs.kurukuruDM = {
      enable = true;

      settings = {
        wallpaper = listening;
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

