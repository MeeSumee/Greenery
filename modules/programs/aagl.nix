{
  config,
  options,
  lib,
  sources,
  ...
}:{

  imports = [
    (sources.aagl + "/module")
  ];
  
  options.greenery.programs.aagl.enable = lib.mkEnableOption "anime games";

  config = lib.mkIf (config.greenery.programs.aagl.enable && config.greenery.programs.enable) {

    nixpkgs.overlays = [
      (import (sources.aagl + "/overlay.nix") {inherit (sources) rust-overlay;})
    ];

    # Cache loader for anime games
    nix.settings.extra-substituters = ["https://ezkea.cachix.org"];
    nix.settings.extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];

    # Enable individual anime games
    programs = {
      # Gayshit Impact
      anime-game-launcher.enable = true;

      # Houkai Railgun
      honkers-railway-launcher.enable = false;

      # Goonless Gooners
      sleepy-launcher.enable = false;

      # Houkai Deadge 3
      honkers-launcher.enable = false;

      # Limited Waves
      wavey-launcher.enable = false;
    };
  };
}