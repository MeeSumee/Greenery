{
  pkgs,
  lib,
  config,
  options,
  ...
}:{
  
  options.greenery.hardware.intelgpu.enable = lib.mkEnableOption "intel graphics";

  config = lib.mkIf (config.greenery.hardware.intelgpu.enable && config.greenery.hardware.enable) {
    
    # Intel graphics packages
    hardware = {
      graphics = {
        extraPackages = with pkgs; [
          vpl-gpu-rt
          intel-media-driver
          intel-vaapi-driver
          libvdpau-va-gl
          intel-ocl
        ];
      };
    };
  };
}