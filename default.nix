# To build systems
# sudo nixos-rebuild --no-reexec --file ./default.nix -A <hostname> <boot|test|switch...>
let
  inherit (builtins) mapAttrs;
  sources = import ./npins;
  pkgs = import sources.nixpkgs {};
  nixosConfig = import (sources.nixpkgs + "/nixos/lib/eval-config.nix");

# Define each nixos config
in {
  quartz = nixosConfig {
    system = null;
    specialArgs = {
      inherit sources;
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
      inherit sources;
      users = ["sumeezome"];
    };

    modules = [
      ./hosts/beryl/configuration.nix
      ./hosts/beryl/hardware-configuration.nix
    ];
  };

  greenery = nixosConfig {
    system = null;
    specialArgs = {
      inherit sources;
      users = ["administrator"];
    };
    
    modules = [
      ./hosts/greenery/configuration.nix
      ./hosts/greenery/hardware-configuration.nix
    ];
  };
}