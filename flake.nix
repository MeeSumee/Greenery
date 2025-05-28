{
  description = "Beryl Flake Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # hjem for declaring files in home
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Asus Numpad Driver (UM5302 and similar models)
    asus-numberpad-driver = {
      url = "github:asus-linux-drivers/asus-numberpad-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Lanzaboote for Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    
    # Nix-Minecraft
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # QEMU VM Maker
    generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-matlab,
    asus-numberpad-driver,
    lanzaboote,
    nix-minecraft,
    hjem,
    generators,
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
      beryl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          flakeOverlays = [nix-matlab.overlay];
        };
        modules = [
          ./hosts/beryl/configuration.nix
          asus-numberpad-driver.nixosModules.default
          
          lanzaboote.nixosModules.lanzaboote
          ({ pkgs, lib, ... }: {
            
            boot.loader.systemd-boot.enable = lib.mkForce false;
            
            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/var/lib/sbctl";
            };
          })
        ];
      };
      greenery = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        
        modules = [
          ./hosts/greenery/configuration.nix
          ./server
        ];
      };
    };
    
    packages = forAllSystems (pkgs: rec {
      berylVM = generators.nixosGenerate {
        inherit (pkgs) system;
        modules = [
          ./VMmaker/beryl.nix
        ];
        format = "vm";
      };
      
      greeneryVM = generators.nixosGenerate {
        inherit (pkgs) system;
        modules = [
          ./VMmaker/greenery.nix
        ];
        format = "vm";
      };
    });
  };
}
