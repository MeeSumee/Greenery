# DEFUNCT, PLEASE VIEW hosts/default.nix FOR SYSTEM BUILDING 
# To build systems
# sudo nixos-rebuild --no-reexec --file ./default.nix -A <hostname> <boot|test|switch...>
let
  inherit (builtins) mapAttrs;
  sources = import ./npins;
  pkgs = import sources.nixpkgs {};
  nixosConfig = import (sources.nixpkgs + "/nixos/lib/eval-config.nix");

  zaphkiel = import sources.zaphkiel {
    inherit sources pkgs;
  };

# Define each nixos config
in {
  quartz = nixosConfig {
    system = null;
    specialArgs = {
      inherit sources zaphkiel;
      users = ["sumee"];
    };
    
    modules = [
      ./hosts/quartz/configuration.nix
      ./hosts/quartz/hardware-configuration.nix
    ];
  };

  beryl = nixosConfig {
    system = null;
    specialArgs = {
      inherit sources zaphkiel;
      users = ["sumee"];
    };

    modules = [
      ./hosts/beryl/configuration.nix
      ./hosts/beryl/hardware-configuration.nix
    ];
  };

  greenery = nixosConfig {
    system = null;
    specialArgs = {
      inherit sources zaphkiel;
      users = ["administrator"];
    };
    
    modules = [
      ./hosts/greenery/configuration.nix
      ./hosts/greenery/hardware-configuration.nix
    ];
  };

  kaolin = nixosConfig {
    system = null;
    specialArgs = {
      inherit sources zaphkiel;
      users = ["sumee"];
    };

    modules = [
      ./hosts/kaolin/configuration.nix
      ./hosts/kaolin/hardware-configuration.nix
    ];
  };

  graphite = nixosConfig {
    system = null;
    specialArgs = {
      inherit sources zaphkiel;
      users = ["sumee"];
    };
    
    modules = [
      ./hosts/graphite/configuration.nix
      ./hosts/graphite/hardware-configuration.nix
    ];
  };
}
