{
  config,
  lib,
  users,
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
      enable = true;
      directory = config.users.users.${user}.home;
      clobberFiles = lib.mkForce true;
      files = {
        ".config/foot/foot.ini".source = ../../dots/foot/foot.ini;
      };
    });    
  };
}
