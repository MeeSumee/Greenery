{
  pkgs,
  lib,
  config,
  ...
}: {
  options.greenery.system.input.enable = lib.mkEnableOption "language input";

  config = lib.mkIf (config.greenery.system.input.enable && config.greenery.system.enable) {
    # Enable fcitx for Input Method Editor (IME)
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        ignoreUserConfig = true;
        addons = with pkgs; [
          fcitx5-mozc # Japanese Input
          fcitx5-rose-pine # Rose Pine Theme
        ];
        settings = {
          addons = {
            classicui.globalSection.Theme = "rose-pine";
          };
          inputMethod = {
            "Groups/0" = {
              "Name" = "Default";
              "Default Layout" = "us";
              "DefaultIM" = "mozc";
            };

            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "mozc";
          };
        };
      };
    };

    # Provides ibus for input method
    environment = {
      variables.GLFW_IM_MODULE = "ibus";
    };
  };
}
