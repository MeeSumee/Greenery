{ 
  config, 
  lib, 
  pkgs, 
  options, 
  ... 
}:{

  options.greenery.hardware.amdgpu.enable = lib.mkEnableOption "amd graphics";

  config = lib.mkIf (config.greenery.hardware.amdgpu.enable && config.greenery.hardware.enable) {
    
    # Set boot to immediately load amdgpu drivers
    boot.initrd.kernelModules = [ "amdgpu" ];
    
    # Set exposed video decode for mpv?
    environment.variables.RADV_PERFTEST = "video_decode";
    
    # Enables AMDVLK Vulkan driver
    hardware.amdgpu.amdvlk.enable = true;

    # Enable OpenGL with AMD Vulkan
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          rocmPackages.clr.icd
          vaapiVdpau
          libvdpau-va-gl
        ];

        extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
      };
    };

    # amd hip
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    # Set xserver video driver
    services.xserver.videoDrivers = ["amdgpu"];

    # Adds rocm support to btop and nixos
    nixpkgs.config.rocmSupport = true;
  };
}