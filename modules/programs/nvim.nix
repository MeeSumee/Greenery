# It's fucking broken, leaving it for now
{ 
  pkgs,
  sources, 
  config, 
  lib, 
  options, 
  ... 
}:{

  # Import hjem
  imports = [
    (sources.hjem + "/modules/nixos")
  ];

  options.greenery.programs.nvim.enable = lib.mkEnableOption "nvim";

  config = lib.mkIf (config.greenery.programs.nvim.enable && config.greenery.programs.enable) {
    /* BEHOLD, SERENITY */
  };
}
