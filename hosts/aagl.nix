{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.aagl.nixosModules.default
  ];
  
  nix.settings = inputs.aagl.nixConfig;
  programs = {
    # Gayshit Impact
    anime-game-launcher.enable = false;
    
    # Houkai Railgun
    honkers-railway-launcher.enable = false;
    
    # Goonless Gooners
    sleepy-launcher.enable = false;
    
    # Houkai Deadge 3
    honkers-launcher.enable = false;
    
    # Limited Waves
    wavey-launcher.enable = false;
  };
}
