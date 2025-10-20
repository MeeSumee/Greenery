{
  config,
  lib,
  users,
  sources,
  ...
}:{
  options.greenery.programs.foot.enable = lib.mkEnableOption "foot";

  config = lib.mkIf (config.greenery.programs.foot.enable && config.greenery.programs.enable) {
    
    # Foot terminal
    programs.foot = {
      enable = true;
    };

    # Foot Theming
    hjem.users = lib.genAttrs users (user: {
      files = {
        ".config/foot/foot.ini".source = ../../dots/foot/foot.ini;
        ".config/foot/rose-pine.ini".source = sources.rosefoot + "/rose-pine";
      };
    });    
  };
}
