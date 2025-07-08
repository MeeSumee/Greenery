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
    files = {
      ".config/uwsm/env".source = ../../dots/uwsm/env;
      ".config/hypr/hyprland.conf".source = ../../dots/hyprland/hyprland.conf;
    };
  });
}
