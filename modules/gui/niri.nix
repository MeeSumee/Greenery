{
  config,
  pkgs,
  options,
  lib,
  flakeOverlays,
  inputs,
  users,
  ...
}: {
  # Import modules
  imports = [
    inputs.niri.nixosModules.niri
    inputs.hjem.nixosModules.default
  ];

  # Niri flake overlay
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];

  # Niri
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };  

  # Xwayland satellite for X11 Windowing Support
  systemd.user.services.xwayland-satellite.wantedBy = [ "graphical-session.target" ];

  # swww auto-run wallpaper daemon
  environment.systemPackages = with pkgs; [
  	swww
  ];
  
  # Niri Hjem config
  hjem.users = lib.genAttrs users (user: {
    enable = true;
    directory = config.users.users.${user}.home;
    clobberFiles = lib.mkForce true;
    files = {
      ".config/niri/config.kdl".source = ../../dots/niri/config.kdl;
    };
  });
}
