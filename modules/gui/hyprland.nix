{
  pkgs,
  options,
  lib,
  config,
  inputs,
  users,
  sources,
  ...
}:{
  imports = [
  	inputs.hjem.nixosModules.default
  ];

  # Hyprland idle daemon
  services.hypridle.enable = true;

  # Hyprland screen locking utility
  programs.hyprlock.enable = true;
  
  # Hyprland for desktop
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Hyprland Packages & Kurukuru bar
  environment.systemPackages = let
    kurukurubar = pkgs.callPackage (sources.zaphkiel + "/pkgs/kurukurubar.nix") {};
    grim = pkgs.grim;
    slurp = pkgs.slurp;
  in [
    kurukurubar
    grim
    slurp
  ];
  
  # Hjem for hyprland configs
  hjem.users = lib.genAttrs users (user: {
    enable = true;
    directory = config.users.users.${user}.home;
    clobberFiles = lib.mkForce true;
    files = let
      hyprwall = let
  	    from = ["%_HOLY_TIDDIES_%"];
  	    sassy_cindrella_girl = pkgs.fetchurl {
   	      name = "hyprlockvivian";
   	      url = "https://img4.gelbooru.com/images/05/eb/05ebf5d940096c87b92497c92770c997.png";
   	      hash = "sha256-lZ9dfCDthBgqewcBrzQOKFr2X5Rc+rlEhPPrO8VQA/g=";
   	    };
  	    to = ["${sassy_cindrella_girl}"];
  	  in
  	    builtins.replaceStrings from to (builtins.readFile ../../dots/hyprland/hyprland.conf);
  	    
	    hyprlockwall = let
	      from = ["$_SCHIZOPHRENIA_$"];
  	    classy_cindrella_girl = pkgs.fetchurl {
  	      name = "hyprvivian";
  	      url = "https://img4.gelbooru.com/images/62/f3/62f3da5821dab06f98cfaf71dc304243.png";
  	      hash = "sha256-X6zdZVYi6iyGc1M065lNlcqMBVQ21RMX2IKOGAzkzqE=";
  	    };	    
	      to = ["${classy_cindrella_girl}"];
	    in
	  	  builtins.replaceStrings from to (builtins.readFile ../../dots/hyprland/hyprlock.conf);
    in {
      ".config/uwsm/env".source = ../../dots/uwsm/env;
      ".config/hypr/hyprland.conf".text = hyprwall;
      ".config/hypr/hyprlock.conf".text = hyprlockwall;
      ".config/hypr/hypridle.conf".source = ../../dots/hyprland/hypridle.conf;
    };
  });
}
