{
  pkgs,
  sources,
  config,
  users,
  ...
}: let
  uwuToHypr = pkgs.runCommandLocal "quick" {} ''
    awk '/^export/ { split($2, ARR, "="); print "env = "ARR[1]","ARR[2]}' ${../../dots/uwsm/env} > $out
  '';
in {
  imports = [(sources.zaphkiel + "/nixosModules/exported/kurukuruDM.nix")];

  programs.kurukuruDM = {
    enable = true;
    package = pkgs.kurukurubar;

    settings = {
      wallpaper = config.hjem.users.${builtins.elemAt users 0}.files.".config/background".source;
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
}