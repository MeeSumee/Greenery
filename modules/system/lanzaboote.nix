{
  zaphkiel,
  pkgs,
  config,
  lib,
  ...
}: 
{
  imports = [zaphkiel.nixosModules.lanzaboote];

  options.greenery.system.lanzaboote.enable = lib.mkEnableOption "lanzaboote";

  config = lib.mkIf (config.greenery.system.lanzaboote.enable && config.greenery.system.enable) {
    environment.systemPackages = [pkgs.sbctl];
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      # WARNING
      # this is from the internal overlay NOT THE SAME as pkgs.lanzaboote-tool
      # in nipxkgs which does NOT contain the required uefi stub
      # package = pkgs.lanzaboote-tool;
      configurationLimit = 12;
    };
  };
}
