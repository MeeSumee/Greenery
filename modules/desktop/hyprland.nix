{
  pkgs,
  lib,
  config,
  users,
  ...
}:{
  
  options.greenery.desktop.hyprland.enable = lib.mkEnableOption "hyprland";

  config = lib.mkIf (config.greenery.desktop.hyprland.enable && config.greenery.desktop.enable) {

    # Hyprland for desktop
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    # Set hyprland as default session
    services.displayManager.defaultSession = "hyprland-uwsm";

    # Hyprland Dependent Packages
    environment.systemPackages = with pkgs; [
      grim
    ];

    # Hjem for hyprland configs
    hjem.users = lib.genAttrs users (user: {
      files = let
        
        # Set hyprland wallpaper
        hyprwall = pkgs.fetchurl {
          name = "hyprvivian";
          url = "https://img4.gelbooru.com/images/05/eb/05ebf5d940096c87b92497c92770c997.png";
          hash = "sha256-lZ9dfCDthBgqewcBrzQOKFr2X5Rc+rlEhPPrO8VQA/g=";
        };
        
        # Set quickshell lockscreen bundled from kurushell
        kokblock = let
          from = ["%%刺し身％％"];
          to = ["kurukurubar ipc call lockscreen lock"];
        in   
          builtins.replaceStrings from to (builtins.readFile ../../dots/hyprland/hypridle.conf);
      in {
        ".config/uwsm/env".source = ../../dots/uwsm/env;
        ".config/hypr/hyprland.conf".source = ../../dots/hyprland/hyprland.conf;
        ".config/background".source = hyprwall;
        ".config/hypr/hypridle.conf".text = kokblock;
      };
    });
  };
}
