{
  config,
  pkgs,
  options,
  lib,
  inputs,
  users,
  ...
}: {
  # Import modules
  imports = [
    inputs.hjem.nixosModules.default
  ];

  # Enable Niri
  programs.niri = {
    enable = true;
  };  

  # Xwayland satellite for X11 Windowing Support
  systemd.user.services.xwayland-satellite.wantedBy = [ "graphical-session.target" ];

  # Niri Packages
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  # Niri Hjem config
  hjem.users = lib.genAttrs users (user: {
    enable = true;
    directory = config.users.users.${user}.home;
    clobberFiles = lib.mkForce true;
    files = let

      # Set niri wallpaper
      niriwall = let
        from = ["*Why_is_IT_department_a_piece_of_shit*"];
        real_life_moment = pkgs.fetchurl {
          name = "apartment";
          url = "https://cdn.donmai.us/original/ae/78/ae78985535779323b7eef717f39e1c0f.gif?download=1";
          hash = "sha256-bx6gG5fJTVJCnpeb/E91FBpNQk+xmXcBJpDDIebkqbg=";
        };
        to = ["${real_life_moment}"];
      in
        builtins.replaceStrings from to (builtins.readFile ../../dots/niri/config.kdl);
    in {
      ".config/niri/config.kdl".text = niriwall;
    };
  });
}

