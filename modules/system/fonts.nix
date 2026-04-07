{
  pkgs,
  lib,
  config,
  ...
}: {
  options.greenery.system.fonts.enable = lib.mkEnableOption "fonts";

  config = lib.mkIf (config.greenery.system.fonts.enable && config.greenery.system.enable) {
    # Fonts
    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        nerd-fonts.caskaydia-mono
        nerd-fonts.caskaydia-cove
        material-symbols
      ];
      fontconfig = {
        defaultFonts = {
          serif = [
            "Noto Serif"
            "Noto Serif Japanese"
            "Noto Serif Simplified Chinese"
          ];
          sansSerif = [
            "Noto Sans"
            "Noto Sans Japanese"
            "Noto Sans Simplified Chinese"
          ];
          monospace = [
            "Noto Sans Mono"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
      };
    };
  };
}
