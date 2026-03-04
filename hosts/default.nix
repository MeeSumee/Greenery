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
        users = ["sumee"];
      };
      modules = [
        ./${hostName}/configuration.nix
        ./${hostName}/hardware-configuration.nix
        ../modules

        # Import packages from flake
        ({pkgs, ...}: {
          nixpkgs.overlays = [
            (_: _: {
              wo = self.packages.${pkgs.stdenv.hostPlatform.system};
            })
          ];
        })
      ];
    };

  hosts = ["beryl" "greenery" "kaolin" "quartz" "verdure"];
in
  genAttrs hosts mkHost
