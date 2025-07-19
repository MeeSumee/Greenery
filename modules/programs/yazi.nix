{ 
  config, 
  lib, 
  pkgs, 
  ...
}: {

  options.greenery.programs.yazi.enable = lib.mkEnableOption "yazi";

  config = lib.mkIf (config.greenery.programs.yazi.enable && config.greenery.programs.enable) {

    programs.yazi = {
      enable = true;

      plugins = with pkgs.yaziPlugins; {
        inherit nord yatline;
      };

      flavors = { inherit (pkgs.yaziPlugins) nord; };

      settings = {
        yazi = {
          mgr = {
            show_hidden = true;
          };
        };
        theme = {
          flavor = {
            light = "nord";
            dark = "nord";
          };
        };
      };
      initLua = ../../dots/yazi/init.lua;
    };
  };
}
