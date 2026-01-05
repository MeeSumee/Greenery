{ 
  config, 
  lib, 
  pkgs, 
  ... 
}:{

  options.greenery.hardware.amdgpu.enable = lib.mkEnableOption "amd graphics";

  config = lib.mkIf (config.greenery.hardware.amdgpu.enable && config.greenery.hardware.enable) {
    
    # Set exposed video decode for mpv?
    environment.variables = {
      RADV_PERFTEST = "video_decode";
      RUSTICL_ENABLE = "radeonsi";
    };
    
    # Enable OpenGL with AMD Vulkan
    hardware = {
      amdgpu.initrd.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa.opencl
          rocmPackages.clr.icd
          libva-vdpau-driver
          libvdpau-va-gl
        ];
      };
    };

    # amd hip
    systemd.tmpfiles.rules = let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

    # Set xserver video driver
    services.xserver.videoDrivers = ["amdgpu"];

    # Adds rocm support to btop and nixos
    nixpkgs.config.rocmSupport = true;
  };
}
