{
  self,
  sources,
  inputs,
  lib,
  ...
}: let
  inherit (lib) genAttrs nixosSystem;
  mkHost = hostName:
    nixosSystem {
      specialArgs = {
        inherit inputs sources;
        mein = self.packages;
        users = ["sumee"];
      };
      modules = [
        ./${hostName}/configuration.nix
        ./${hostName}/hardware-configuration.nix
        ../modules
      ];
    };

  hosts = ["beryl" "greenery" "graphite" "kaolin" "quartz"];
in
  genAttrs hosts mkHost
