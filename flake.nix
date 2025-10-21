# Maybe the real flake is the 友達 we made along da wei.
# Once again nahida will look by my shoulders wondering why am I wasting so much time on NixOS.
{
  description = "MeeSumee's Flake Config";

  inputs = {

    # NixOS Unstable
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Hjem
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.smfh.follows = "";
    };

    # Asusu numberpad driver
    asusnumpad = {
      url = "github:asus-linux-drivers/asus-numberpad-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ecchirexi
    ecchirexi = {
      url = "github:Rexcrazy804/hjem-impure";
      inputs.nixpkgs.follows = "";
      inputs.hjem.follows = "";
    };

    # Nix-Systems
    systems.url = "github:nix-systems/default";

    # Lanzaboote
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = "";
      inputs.flake-compat.follows = "";
    };

    # Anime-game
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };

    # Zaphkiel config
    zaphkiel = {
      url = "github:Rexcrazy804/Zaphkiel";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hjem.follows = "";
      inputs.hjem-impure.follows = "";
      inputs.agenix.follows = "";
      inputs.crane.follows = "";
      inputs.stash.follows = "";
      inputs.booru-hs.follows = "";
      inputs.hs-todo.follows = "";
    };

    # Agenix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
  };

  # RexCrazy804 Schematic
  outputs = inputs: let
    inherit (inputs) nixpkgs self;
    inherit (nixpkgs) lib;

    # Define each system architecture
    systems = import inputs.systems;

    # npin integration to flakes
    sources = import ./npins;

    callModule = {
      __functor = self: path: attrs: import path (self // attrs);
      inherit inputs self lib sources;
    };

    pkgsFor = system: nixpkgs.legacyPackages.${system};
    eachSystem = fn: lib.genAttrs systems (system: fn (pkgsFor system));

  in {
    formatter = eachSystem (pkgs: inputs.zaphkiel.packages.${pkgs.system}.irminsul);

    packages = eachSystem (pkgs:{ 
      default = pkgs.callPackage ./pkgs/cursors.nix {};
    });

    nixosConfigurations = callModule ./hosts {};
  };
}
