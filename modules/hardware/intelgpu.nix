{
  pkgs,
  lib,
  config,
  ...
}:{
  
  options.greenery.hardware.intelgpu.enable = lib.mkEnableOption "intel graphics";

  config = lib.mkIf (config.greenery.hardware.intelgpu.enable && config.greenery.hardware.enable) {

    # Failsafe if FFMPEG/QSV fails to initialize
    boot.kernelParams = [ "i915.enable_guc=3" ];
    
    # Intel graphics packages
    hardware = {
      enableRedistributableFirmware = true;
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-ocl
          intel-media-driver
          vpl-gpu-rt
        ];
      };
    };

    # Suggest intel HD graphics to programs that use iGPU
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };
}
