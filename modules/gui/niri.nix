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

  # Niri Packages
  environment.systemPackages = with pkgs; [
  	swww
  	xwayland-satellite
  ];
  
  # Niri Hjem config
  hjem.users = lib.genAttrs users (user: {
    enable = true;
    directory = config.users.users.${user}.home;
    clobberFiles = lib.mkForce true;
    files = let
      niriwall = let
		from = ["*SWALLOW_MY_OCTOPUS_WEINER*"];
        swallow = pkgs.fetchurl {
          name = "apartment";
          url = "https://cdn.donmai.us/original/ae/78/ae78985535779323b7eef717f39e1c0f.gif?download=1";
          hash = "sha256-bx6gG5fJTVJCnpeb/E91FBpNQk+xmXcBJpDDIebkqbg=";
        };
        to = ["${swallow}"]; 
      in
        builtins.replaceStrings from to (builtins.readFile ../../dots/niri/config.kdl);
    in {
      ".config/niri/config.kdl".text = niriwall;
    };
  });
}

