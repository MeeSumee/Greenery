{
  description = "MeeSumee's Flake Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Niri-flake
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Quickshell UI-maker
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
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
  };

  outputs = {
    self,
    nixpkgs,
    niri,
    nix-matlab,
    asus-numberpad-driver,
    lanzaboote,
    nix-minecraft,
    hjem,
    quickshell,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = fn:
      nixpkgs.lib.genAttrs systems (
        system: fn (import nixpkgs {system = system;})
      );
  in {
    packages = forAllSystems (pkgs: { 
      default = pkgs.callPackage ./pkgs/cursors.nix {};
    });
    
    formatter = forAllSystems (pkgs: pkgs.alejandra);
    nixosConfigurations = {
      beryl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./hosts/beryl/configuration.nix
          ./hosts/beryl/hardware-configuration.nix
          ./hosts/beryl/battery.nix
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
          ./hosts/greenery/hardware-configuration.nix
          ./server
        ];
      };
      
      BVM = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        
        modules = [
          ./vmmaker/beryl.nix
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
      
      GVM = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        
        modules = [
          ./vmmaker/greenery.nix
        ];
      };
    };
  };
}
