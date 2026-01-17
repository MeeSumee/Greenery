{ 
  config, 
  lib, 
  pkgs, 
  ...
}: {
  options.greenery.desktop.sddm.enable = lib.mkEnableOption "Simple display manager";

  config = lib.mkIf (config.greenery.desktop.sddm.enable && config.greenery.desktop.enable) {

    # Enable sddm display manager
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      theme = ''
        ${pkgs.catppuccin-sddm.override
          {
            flavor = "mocha";
            accent = "mauve";
            font  = "CaskaydiaMono Nerd Font";
            fontSize = "24";
            clockEnabled = true;
            userIcon = true;
          }
        }/share/sddm/themes/catppuccin-mocha-mauve
      '';

      settings = {
        Theme = {
          CursorTheme = "xcursor-genshin-nahida";
          CursorSize = 24;
        };
      };
    };
  };
}
