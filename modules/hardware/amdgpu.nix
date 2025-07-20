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
    
    # Include dependent packages
    environment.systemPackages = [
      pkgs.radeontop
    ];
    
    # Enables AMDVLK Vulkan driver
    hardware.amdgpu.amdvlk.enable = true;

    # Enable OpenGL with AMD Vulkan
    hardware = {
      graphics = {
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

    # rocdbgapi has a problem with building in 25.11
    # https://github.com/NixOS/nixpkgs/issues/421822
    # https://hydra.nixos.org/job/nixpkgs/trunk/rocmPackages_6.rocdbgapi.x86_64-linux/all
    # The temp solution that goes over it eats up RAM

    # Adds rocm support to btop and nixos
#    nixpkgs.config.rocmSupport = true;
  };
}