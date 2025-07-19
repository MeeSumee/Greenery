{
  pkgs,
  lib,
  options,
  config,
  ...
}: {
  options.greenery.system.input.enable = lib.mkEnableOption "language input";

  config = lib.mkIf (config.greenery.system.input.enable && config.greenery.system.enable) {
    
    # Enable fcitx for Input Method Editor (IME)
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
    };
    
    # Add and enable mozc as input method in fcitx. Good for JP input.
    i18n.inputMethod.fcitx5 = {

      waylandFrontend = true;

      addons = [ pkgs.fcitx5-mozc ];
      
      settings.inputMethod = {
        "Groups/0" = {
          "Name" = "Default";
          "Default Layout" = "us";
          "DefaultIM" = "mozc";
        };
        "Groups/0/Items/0" = {
          "Name" = "keyboard-us";
          "Layout" = null;
        };
        "Groups/0/Items/1" = {
          "Name" = "mozc";
          "Layout" = null;
        };
      };
    };
    
    # Provides ibus for input method
    environment.variables.GLFW_IM_MODULE = "ibus";
  };
}
