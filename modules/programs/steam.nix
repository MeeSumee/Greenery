{
  config,
  lib,
  ...
}:{

  options.greenery.programs.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf (config.greenery.programs.steam.enable && config.greenery.programs.enable) {

    # Gaseous H2O
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;                # Gamescope for native xwayland windows
    };
  };
}
