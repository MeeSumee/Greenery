{
  pkgs,
  lib,
  config,
  sources,
  users,
  ...    
}:{
  imports = [
    (sources.sops + "/modules/sops")
  ];

  options.greenery.system.sops.enable = lib.mkEnableOption "sops";

  config = lib.mkIf (config.greenery.system.sops.enable && config.greenery.system.enable) {

  };
}
