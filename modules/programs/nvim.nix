{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {

  options.greenery.programs.nvim.enable = mkEnableOption "nvim";

  # nvim config by the cutie himself :D
  config = mkIf (config.greenery.programs.nvim.enable && config.greenery.programs.enable) {
    environment.systemPackages = [pkgs.zpkgs.xvim.vivi];
  };
}
