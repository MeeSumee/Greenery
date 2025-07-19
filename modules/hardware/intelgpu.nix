{
  pkgs,
  lib,
  config,
  options,
  ...
}:{
  
  options.greenery.hardware.intelgpu.enable = lib.mkEnableOption "intel graphics";

  config = lib.mkIf (config.greenery.hardware.intelgpu.enable && config.greenery.hardware.enable) {
    /* for future addition in making gpu passthru working */
  };
}