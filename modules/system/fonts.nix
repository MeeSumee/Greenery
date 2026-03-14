{
  pkgs,
  lib,
  config,
  ...
}: {
  options.greenery.system.fonts.enable = lib.mkEnableOption "fonts";

  config = lib.mkIf (config.greenery.system.fonts.enable && config.greenery.system.enable) {
    # Fonts
    fonts.packages = with pkgs; [
      kochi-substitute
      nerd-fonts.caskaydia-mono
      nerd-fonts.caskaydia-cove
      material-symbols
    ];
  };
}
