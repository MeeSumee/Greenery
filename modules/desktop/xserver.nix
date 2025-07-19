{
  config,
  lib,
  options,
  pkgs,
  ...
}:{

  options.greenery.desktop.xserver.enable = lib.mkEnableOption "X11 windowing";

  config = lib.mkIf (config.greenery.desktop.xserver.enable && config.greenery.desktop.enable) {

    # Enable the X11 windowing system
    services.xserver = {
      enable = true;
      excludePackages = with pkgs; [ xterm ];
      displayManager = {
        setupCommands = ''
        '';
      };
    };
  };
}