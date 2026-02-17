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
      inputs.nix-darwin.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.smfh.follows = "";
    };

    # Asusu numberpad driver
    asusnumpad = {
      url = "github:asus-linux-drivers/asus-numberpad-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix-Systems
    systems.url = "github:nix-systems/default";

    # Nix WSL for Graphite (Worktop)
    wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };

    # Lanzaboote
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit.follows = "";
    };

    # Anime-game
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };

    # nvim nvf
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
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

  # Short, but fucked Schematic
  outputs = inputs: let
    # Essentially takes in everything
    inherit (inputs) nixpkgs self systems;
    # inherits lib to be used below
    inherit (nixpkgs) lib;

    # npin integration to flakes
    sources = import ./npins;

    # pkgsFor defines x64/ARM/darwin etc with systems input
    pkgsFor = lib.getAttrs (import systems) nixpkgs.legacyPackages;

    # moduleArgs defined for callModule
    moduleArgs = {
      inherit
        inputs
        self
        sources
        lib
        ;
    };

    # I don't understand this, ask rex
    eachSystem = fn: lib.mapAttrs (system: pkgs: fn {inherit system pkgs;}) pkgsFor;

    # callModule calls a .nix file
    callModule = path: attrs: import path (moduleArgs // attrs);
  in {
    # alejandra formatter from upstream
    formatter = eachSystem ({pkgs, ...}: pkgs.alejandra);

    # defines self's packages (nahida cursor etc)
    packages = eachSystem (attrs: callModule ./pkgs attrs);

    # nixos systems configured (greenery, quartz etc)
    nixosConfigurations = callModule ./hosts {};

    # checks to validate and build systems (used in GitHub CI)
    # imports from nixosConfigurations and iterates between each one as "nixos-quartz", "nixos-beryl", etc
    # thanks Mic92
    checks = nixpkgs.lib.genAttrs (import systems) (
      system: let
        inherit (nixpkgs) lib;
        nixosMachines =
          lib.mapAttrs' (name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel)
          (
            (lib.filterAttrs (_: config: config.pkgs.stdenv.hostPlatform.system == system))
            self.nixosConfigurations
          );
      in
        nixosMachines
    );
  };
}
