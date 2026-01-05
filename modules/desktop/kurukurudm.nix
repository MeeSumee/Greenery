{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  listening = pkgs.fetchurl {
    name = "listening";
    url = "https://cdn.donmai.us/original/bb/e8/bbe8f1413839cdacc56b28e05c502d5d.jpg?download=1";
    hash = "sha256-XbrujvmGo90L7EOY5i1ydc3GQi77NJ68mxVHyMMq5gg=";
  };

in {
  imports = [inputs.zaphkiel.nixosModules.kurukuruDM];

  options.greenery.desktop.kurukurudm.enable = lib.mkEnableOption "rex's desktop manager";

  config = lib.mkIf (config.greenery.desktop.kurukurudm.enable && config.greenery.desktop.enable) {

    # Set wallpaper
    programs.kurukuruDM.settings.wallpaper = listening;

    # Set niri as base for rex's DM
    services.greetd.settings.default_session.command = let
      cfg = config.programs.kurukuruDM;
      autostart = pkgs.writeShellScript "autostart.sh" ''
        ${cfg.finalOpts} ${cfg.package}/bin/kurukurubar && pkill niri
      '';
      niri = pkgs.writeText "config.kdl" ''
        output "eDP-1" {
          mode "2880x1800@60"
          scale 1.5
          transform "normal"
          position x=0 y=0
        }
        cursor {
          xcursor-theme "xcursor-genshin-nahida"
          xcursor-size 36
        }
        spawn-at-startup "${autostart}"
      '';
    in
      lib.mkForce "${config.programs.niri}/bin/niri -c ${niri}";
  };
}

