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
      files = let

        # Set hyprlock wallpaper
        hyprlockwall = let
          from = ["$_SCHIZOPHRENIA_$"];
          roses = pkgs.fetchurl {
            name = "roses";
            url = "https://cdn.donmai.us/original/bb/e8/bbe8f1413839cdacc56b28e05c502d5d.jpg?download=1";
            hash = "sha256-XbrujvmGo90L7EOY5i1ydc3GQi77NJ68mxVHyMMq5gg=";
          };	    
          to = ["${roses}"];
        in
          builtins.replaceStrings from to (builtins.readFile ../../dots/hyprland/hyprlock.conf);

      in {
        ".config/hypr/hyprlock.conf".text = hyprlockwall;
      };
    });
  };
}
