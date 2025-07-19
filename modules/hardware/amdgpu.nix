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

    environment.systemPackages = [pkgs.radeontop];
    
    # Enables AMDVLK Vulkan driver
    hardware.amdgpu.amdvlk.enable = true;

# rocm has a problem with building in 25.11
# https://github.com/NixOS/nixpkgs/issues/421822
# The temp solution that goes over it eats up RAM

    # Enable OpenGL with AMD Vulkan
    hardware = {
      graphics = {
        extraPackages = with pkgs; [
#          rocmPackages.clr.icd
          vaapiVdpau
          libvdpau-va-gl
        ];

        extraPackages32 = with pkgs; [driversi686Linux.amdvlk];
      };
    };

    # Set xserver video driver
    services.xserver.videoDrivers = ["amdgpu"];

    # Adds rocm support to btop and nixos
#    nixpkgs.config.rocmSupport = true;
    /*
    # amd hip
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
    */
  };
}