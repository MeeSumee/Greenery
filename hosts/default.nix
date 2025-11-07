{
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

        # Import zaphkiel packages from flake
        ({
          pkgs,
          inputs,
          ...
          }:{
            nixpkgs.overlays = [(_: _: {zpkgs = inputs.zaphkiel.packages.${pkgs.system}; } )];
        })
      ];
    };

  hosts = ["beryl" "greenery" "graphite" "kaolin" "quartz" "verdure"];
in
  genAttrs hosts mkHost
