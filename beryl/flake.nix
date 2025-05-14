{
  description = "Beryl Flake Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Yuan shen & other Zhongguo Games
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # MethLab
    nix-matlab = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-matlab,
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
      Sumeezome = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          flakeOverlays = [nix-matlab.overlay];
        };
        modules = [
          ./hosts/Sumeezome/configuration.nix
        ];
      };
    };
  };
}
