{
  description = "Server Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # hjem for declaring files in home
    # hjem = {
    #   url = "github:feel-co/hjem";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-minecraft = {
	url = "github:Infinidoge/nix-minecraft";
	inputs.nixpkgs.follows = "nixpkgs";
    };
    mms = {
	url = "github:mkaito/nixos-modded-minecraft-servers";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = fn:
      nixpkgs.lib.genAttrs systems (
        system: fn (import nixpkgs {system = system;})
      );
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);
    nixosConfigurations = {
      administrator = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };

        modules = [
          ./hosts/administrator/configuration.nix
	  ./server
        ];
      };
    };
  };
}
