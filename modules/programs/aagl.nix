{
  config,
  lib,
  inputs,
  ...
}:{

  imports = [
    inputs.aagl.nixosModules.default
  ];
  
  options.greenery.programs.aagl.enable = lib.mkEnableOption "anime games";

  config = lib.mkIf (config.greenery.programs.aagl.enable && config.greenery.programs.enable) {

    # Cache loader for anime games
    nix.settings = inputs.aagl.nixConfig;

    # Enable individual anime games
    programs = {
      # Gayshit Impact
      anime-game-launcher.enable = true;

      # Houkai Railgun
      honkers-railway-launcher.enable = false;

      # Goonless Gooners
      sleepy-launcher.enable = false;

      # Houkai Deadge 3
      honkers-launcher.enable = false;

      # Limited Waves
      wavey-launcher.enable = false;
    };
  };
}
