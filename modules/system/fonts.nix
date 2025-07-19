{
  pkgs,
  lib,
  options,
  config,
  ...
}: {

  options.greenery.system.fonts.enable = lib.mkEnableOption "fonts";

  config = lib.mkIf (config.greenery.system.fonts.enable && config.greenery.system.enable) {

    # Fonts
    fonts.packages = with pkgs; [
      carlito
      dejavu_fonts
      ipafont
      kochi-substitute
      source-code-pro
      ttf_bitstream_vera
      nerd-fonts.caskaydia-mono
      nerd-fonts.caskaydia-cove
      material-symbols
    ];
  };
}