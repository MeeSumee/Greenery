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
  in [kurukurubar];  
  
  # Hjem for hyprland configs
  hjem.users = lib.genAttrs users (user: {
    enable = true;
    directory = config.users.users.${user}.home;
    clobberFiles = lib.mkForce true;
    files = let
	  hyprlockwall = let
	    from = ["HOLLOW_BALLS"];
	    medieval_cindrella_girl = pkgs.fetchurl {
	      name = "vivianlock";
	      url = "https://cdn.donmai.us/original/17/4a/__vivian_banshee_zenless_zone_zero_drawn_by_mayogii__174a8c56824581a8f8a8da9449b82863.jpg?download=1";
	      hash = "sha256-T4/lY3noWrXmZQ7nzsoHl+Bppt88mSIeqtqvtERPg2M=";
	    };
	    to = ["${medieval_cindrella_girl}"];
	  in
	  	builtins.replaceStrings from to (builtins.readFile ../../dots/hyprland/hyprlock.conf);
    in {
      ".config/uwsm/env".source = ../../dots/uwsm/env;
      ".config/hypr/hyprland.conf".source = ../../dots/hyprland/hyprland.conf;
      ".config/hypr/hypridle.conf".source = ../../dots/hyprland/hypridle.conf;
      ".config/hypr/hyprlock.conf".text = hyprlockwall;
    };
  });
}
