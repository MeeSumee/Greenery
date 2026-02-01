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

    # Noctalia Shell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Zaphkiel config
    zaphkiel = {
      url = "git+https://codeberg.org/Rexcrazy804/Zaphkiel";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.hjem.follows = "";
      inputs.hjem-impure.follows = "";
      inputs.agenix.follows = "";
      inputs.crane.follows = "";
      inputs.stash.follows = "";
      inputs.booru-hs.follows = "";
      inputs.hs-todo.follows = "";
      inputs.nixos-wsl.follows = "";
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
    inherit (inputs) nixpkgs self systems;
    inherit (nixpkgs) lib;

    # npin integration to flakes
    sources = import ./npins;

    pkgsFor = lib.getAttrs (import systems) nixpkgs.legacyPackages;

    moduleArgs = {inherit inputs self sources lib;};

    eachSystem = fn: lib.mapAttrs (system: pkgs: fn {inherit system pkgs;}) pkgsFor;

    callModule = path: attrs: import path (moduleArgs // attrs);

  in {
    formatter = eachSystem ({pkgs,...}: pkgs.alejandra);

    packages = eachSystem (attrs: callModule ./pkgs attrs);

    nixosConfigurations = callModule ./hosts {};

    checks = nixpkgs.lib.genAttrs (import systems) (
      system:
      let
        inherit (nixpkgs) lib;
        nixosMachines = lib.mapAttrs' (
          name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel
        ) ((lib.filterAttrs (_: config: config.pkgs.stdenv.hostPlatform.system == system)) self.nixosConfigurations);
      in
      nixosMachines
    );
  };
}
