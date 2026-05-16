{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  options.greenery.system.lanzaboote.enable = lib.mkEnableOption "lanzaboote";

  config = lib.mkIf (config.greenery.system.lanzaboote.enable && config.greenery.system.enable) {
    environment.systemPackages = [pkgs.sbctl];
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      configurationLimit = 5;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
