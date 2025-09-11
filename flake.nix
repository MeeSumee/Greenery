# Maybe the real flake is the 友達 we made along da wei.
# Once again nahida will look by my shoulders wondering why am I wasting so much time on NixOS.
{
  description = "MeeSumee's Flake Config";

  inputs = {

    # NixOS Unstable
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Hjem
    hjem.url = "github:feel-co/hjem";

    # ecchirexi
    ecchirexi.url = "github:Rexcrazy804/hjem-impure";

    # Nix-Systems
    systems.url = "github:nix-systems/default";

    # Quickshilling Bingchilling
    quickshell = {
      url = "github:Rexcrazy804/quickshell?ref=overridable-qs-unwrapped";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zaphkiel config
    zaphkiel = {
      url = "github:Rexcrazy804/Zaphkiel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Agenix
    agenix = {
      url = "github:ryantm/agenix";
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
    packages = eachSystem (pkgs: callModule ./pkgs {inherit pkgs;});
    nixosConfigurations = callModule ./hosts {};
  };
}
