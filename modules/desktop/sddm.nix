{ 
  config, 
  lib, 
  pkgs, 
  ...
}: let
  listen = pkgs.fetchurl {
    name = "listening";
    url = "https://cdn.donmai.us/original/bb/e8/bbe8f1413839cdacc56b28e05c502d5d.jpg?download=1";
    hash = "sha256-XbrujvmGo90L7EOY5i1ydc3GQi77NJ68mxVHyMMq5gg=";
  };

in {
  options.greenery.desktop.sddm.enable = lib.mkEnableOption "Simple display manager";

  config = lib.mkIf (config.greenery.desktop.sddm.enable && config.greenery.desktop.enable) {

    # Enable gnome display manager
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      theme = ''
        ${pkgs.catppuccin-sddm.override
          {
            flavor = "latte";
            accent = "mauve";
            font  = "CaskaydiaMono Nerd Font";
            fontSize = "9";
            clockEnabled = true;
            background = listen;
            loginBackground = true;
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
