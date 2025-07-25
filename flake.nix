{
  description = "MeeSumee's Flake Config";

# NO MORE INPUTS DAYO

  outputs = {
    self,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Define each system architecture
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

    # Import nixpkgs npin
    nixpkgs = (import sources.flake-compat {src = sources.nixpkgs;}).outputs;

    # npin integration to flakes
    sources = import ./npins;

    forAllSystems = fn:
      nixpkgs.lib.genAttrs systems (
        system: fn (import nixpkgs {system = system;})
      );
    
  in {
    # 
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    # External packages to build
    packages = forAllSystems (pkgs: { 
      default = pkgs.callPackage ./pkgs/cursors.nix {};
    });
  };
}
