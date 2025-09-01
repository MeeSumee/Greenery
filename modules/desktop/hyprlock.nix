{ 
  users, 
  config,
  lib,
  pkgs, 
  ... 
}:{
  
  options.greenery.desktop.hyprlock.enable = lib.mkEnableOption "hyprlock";

  config = lib.mkIf (config.greenery.desktop.hyprlock.enable && config.greenery.desktop.enable) {

    # Hyprland screen locking utility
    programs.hyprlock.enable = true;
    
    # Set hyprlock dot file
    hjem.users = lib.genAttrs users (user: {
      enable = true;
      directory = config.users.users.${user}.home;
      clobberFiles = lib.mkForce true;
      files = let

        # Set hyprlock wallpaper
        hyprlockwall = let
          from = ["$_SCHIZOPHRENIA_$"];
          classy_cindrella_girl = pkgs.fetchurl {
            name = "hyprlockvivian";
            url = "https://img4.gelbooru.com/images/62/f3/62f3da5821dab06f98cfaf71dc304243.png";
            hash = "sha256-X6zdZVYi6iyGc1M065lNlcqMBVQ21RMX2IKOGAzkzqE=";
          };	    
          to = ["${classy_cindrella_girl}"];
        in
          builtins.replaceStrings from to (builtins.readFile ../../dots/hyprland/hyprlock.conf);

      in {
        ".config/hypr/hyprlock.conf".text = hyprlockwall;
      };
    });
  };
}
