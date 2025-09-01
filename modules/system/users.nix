{
  config,
  sources,
  lib,
  pkgs,
  ...
} @ args: let

  inherit (lib) mkEnableOption mkMerge mkIf;
  inherit (lib.modules) importApply;

  argsWith = attrs: args // attrs;
  hjem-lib = import (sources.hjem + "/lib.nix") {
    inherit lib pkgs;
  };
  hjemModule = importApply (sources.hjem + "/modules/nixos") (argsWith {
    inherit hjem-lib;
  });

in {
  imports = [hjemModule];

  # Options maker
  options.greenery.system = {
    sumee.enable = mkEnableOption "Enable the SUMEE user";
    nahida.enable = mkEnableOption "MY WIFE WANTS TO USE MY COMPUTER(s)";
    yang.enable = mkEnableOption "Enable the YANG (good) user";
  };
  
  # WIP, will be completed later
  config = mkMerge [
    
    # WHERE DOES THE STOMEE LIVE???
    (mkIf (config.greenery.system.sumee.enable && config.greenery.system.enable) {
      
    })
    
    # SHE'S MAKING A SUPERCOMPUTER IN MINECRAFT AGAIN????
    (mkIf (config.greenery.system.nahida.enable && config.greenery.system.enable) {

    })

    # 陽ーおじさん wants to use my computer to learn linux sex
    (mkIf (config.greenery.system.yang.enable && config.greenery.system.enable) {

    })
  ];
}
