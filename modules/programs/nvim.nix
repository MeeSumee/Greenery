{
  zaphkiel,
  sources,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  # Import hjem
  imports = [
    (sources.hjem + "/modules/nixos")
  ];

  options.greenery.programs.nvim.enable = mkEnableOption "nvim";

  config = mkIf (config.greenery.programs.nvim.enable && config.greenery.programs.enable) {
    environtment.systemPackages = [zaphkiel.packages.nixvim];
  };
}
