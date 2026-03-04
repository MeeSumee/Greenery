{
  config,
  lib,
  ...
}: {
  options.greenery.programs.foot.enable = lib.mkEnableOption "foot";

  config = lib.mkIf (config.greenery.programs.foot.enable && config.greenery.programs.enable) {
    # Foot terminal
    programs.foot = {
      enable = true;
      theme = "rose-pine";
      settings = {
        main = {
          gamma-correct-blending = false;
          dpi-aware = "yes";
          font = "CaskaydiaMono Nerd Font:size=10";
          font-bold = "CaskaydiaMono Nerd Font:weight=bold:size=10";
          font-bold-italic = "CaskaydiaMono Nerd Font:weight=bold:slant=italic:size=10";
          font-italic = "CaskaydiaMono Nerd Font:slant=italic:size=10";
          pad = "5x5 center";
        };
        security = {
          osc52 = "enabled";
        };
        scrollback = {
          lines = 2000;
          multiplier = 2.0;
          indicator-format = "line";
        };
        cursor = {
          unfocused-style = "hollow";
          blink = "yes";
        };
        mouse = {
          hide-when-typing = true;
        };
        key-bindings = {
          search-start = "Control+Shift+f";
        };
        colors = {
          alpha = 0.8;
        };
      };
    };
  };
}
