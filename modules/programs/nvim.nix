{
  zaphkiel,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {

  options.greenery.programs.nvim.enable = mkEnableOption "nvim";

  # Nightfox themed nvim config by the cutie himself :D
  config = mkIf (config.greenery.programs.nvim.enable && config.greenery.programs.enable) {
    environment.systemPackages = [zaphkiel.packages.xvim.vivi];
  };
}
