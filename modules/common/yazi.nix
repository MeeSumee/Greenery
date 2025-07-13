{ config, lib, pkgs, ...}:
{
  programs.yazi = {
  	enable = true;

  	plugins = with pkgs.yaziPlugins; {
  	  inherit nord yatline;
  	};

  	flavors = { inherit (pkgs.yaziPlugins) nord; };

  	settings = {
  	  theme = {
  	    flavor = {
  	      light = "nord";
  	      dark = "nord";
  	    };
  	  };
  	};
  	initLua = ../../dots/yazi/init.lua;
  };
}
