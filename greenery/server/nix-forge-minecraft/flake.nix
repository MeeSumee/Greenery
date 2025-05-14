{
  description = "A minimal Flake template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    generators,
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (
        system:
          f (import nixpkgs {
            inherit system;
          })
      );
  in {
    packages = forAllSystems (pkgs: rec {
      minecraftVM = generators.nixosGenerate {
        inherit (pkgs) system;
        modules = [
          ./configurations/minecraft.nix
        ];
        format = "vm";
      };

      # used for testing mcLibs independently
      mcLibs = pkgs.callPackage ./pkgs/mcLibBuilder.nix {
        mcVersion = "1.20.1";
        forgeVersion = "47.3.0";
        installerHash = "sha256-YBirzpXMBYdo42WGX9fPO9MbXFUyMdr4hdw4X81th1o=";
        libHash = "sha256-8I6tAOAhaQZzjUtbI137pzL6lw/I3taxuK4EZx6cRIs=";
      };
      # same as above
      modpack = pkgs.callPackage ./pkgs/modpacks/gravitas.nix {};
      # a wonky script to quickly bootrap everything into the current directory and trying to run it
      # doesn't support MODPACKS yet
      mcTestRunner = pkgs.callPackage ./pkgs/hackyRunner.nix {inherit mcLibs;};

      default = minecraftVM;
    });
  };
}
