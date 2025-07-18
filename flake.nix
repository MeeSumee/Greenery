{
  description = "MeeSumee's Flake Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
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
    
    # NVF, Neovim + Nix Config
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    asus-numberpad-driver,
    lanzaboote,
    nvf,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = fn:
      nixpkgs.lib.genAttrs systems (
        system: fn (import nixpkgs {system = system;})
      );

    # npin integration to flakes
    sources = import ./npins;
    
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
          ./hosts/common-hardware.nix
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
          ./hosts/common-hardware.nix
          ./hosts/beryl/configuration.nix
          ./hosts/beryl/hardware-configuration.nix
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
          inherit inputs outputs sources;
          users = ["administrator"];
        };
        
        modules = [
          ./hosts/common-hardware.nix
          ./hosts/greenery/configuration.nix
          ./hosts/greenery/hardware-configuration.nix
          ./modules/server
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
      
      GVM = nixpkgs.lib.nixosSystem {

        specialArgs = {
          inherit inputs outputs sources;
          users = ["greenery"];
        };
        
        modules = [
          ./hosts/vmmaker/greenery.nix
        ];
      };
    };
  };
}
