{
  pkgs,
  options,
  lib,
  config,
  users,
  sources,
  ...
}:{
  
  imports = [
    (sources.hjem + "/modules/nixos")
  ];
  
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

    # Hyprland Dependent Packages & Kurukuru bar
    environment.systemPackages = let
      kurukurubar = pkgs.callPackage (sources.zaphkiel + "/pkgs/kurukurubar.nix") { 
        librebarcode = pkgs.callPackage (sources.zaphkiel + "/pkgs/librebarcode.nix") {}; 
      };
    in [
      kurukurubar
      pkgs.grim
    ];

    # Hjem for hyprland configs
    hjem.users = lib.genAttrs users (user: {
      enable = true;
      directory = config.users.users.${user}.home;
      clobberFiles = lib.mkForce true;
      files = let
        
        # Set hyprland wallpaper
        hyprwall = pkgs.fetchurl {
          name = "hyprvivian";
          url = "https://img4.gelbooru.com/images/05/eb/05ebf5d940096c87b92497c92770c997.png";
          hash = "sha256-lZ9dfCDthBgqewcBrzQOKFr2X5Rc+rlEhPPrO8VQA/g=";
        };
        
      in {
        ".config/uwsm/env".source = ../../dots/uwsm/env;
        ".config/hypr/hyprland.conf".source = ../../dots/hyprland/hyprland.conf;
        ".config/background".source = hyprwall;
      };
    });
  };
}
