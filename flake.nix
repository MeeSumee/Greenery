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
    # External packages to build
    packages = forAllSystems (pkgs: { 
      default = pkgs.callPackage ./pkgs/cursors.nix {};
    });

    # Define nixos configurations for each host
    formatter = forAllSystems (pkgs: pkgs.alejandra);
    nixosConfigurations = {

      quartz = nixpkgs.lib.nixosSystem {

        specialArgs = {
          inherit inputs outputs sources;
          users = ["sumee"];
        };
        
        modules = [
          ./hosts/quartz/configuration.nix
          ./hosts/quartz/hardware-configuration.nix
        ];
      };

      beryl = nixpkgs.lib.nixosSystem {

        specialArgs = {
          inherit inputs outputs sources;
          users = ["sumeezome"];
        };

        modules = [
          ./hosts/beryl/configuration.nix
          ./hosts/beryl/hardware-configuration.nix
        ];
      };

      greenery = nixpkgs.lib.nixosSystem {

        specialArgs = {
          inherit inputs outputs sources;
          users = ["administrator"];
        };
        
        modules = [
          ./hosts/greenery/configuration.nix
          ./hosts/greenery/hardware-configuration.nix
        ];
      };
      
      BVM = nixpkgs.lib.nixosSystem {

        specialArgs = {
          inherit inputs outputs sources;
          users = ["beryl"];
        };
        
        modules = [
          ./hosts/vmmaker/beryl.nix
        ];
      };
      
      QVM = nixpkgs.lib.nixosSystem {

        specialArgs = {
          inherit inputs outputs sources;
          users = ["quartz"];
        };
        
        modules = [
          ./hosts/vmmaker/quartz.nix
        ];
      };
    };
  };
}
