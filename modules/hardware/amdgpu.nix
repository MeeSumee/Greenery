{
  config,
  lib,
  pkgs,
  ...
}: {
  options.greenery.hardware.amdgpu.enable = lib.mkEnableOption "amd graphics";

  config = lib.mkIf (config.greenery.hardware.amdgpu.enable && config.greenery.hardware.enable) {
    # Set exposed video decode for mpv?
    environment.variables = {
      RADV_PERFTEST = "video_decode";
      RUSTICL_ENABLE = "radeonsi";
    };

    # AMD Graphics settings
    hardware = {
      amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
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

    # Adds rocm support to btop and nixos
    nixpkgs.config.rocmSupport = true;
  };
}
