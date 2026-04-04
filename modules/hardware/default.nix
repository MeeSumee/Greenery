{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [
    ./amdgpu.nix
    ./asus-numpad.nix
    ./audio.nix
    ./fprint.nix
    ./intelgpu.nix
    ./power.nix
    ./tpm.nix

    # Scans undetected hardware
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Import hardware modules
  options.greenery.hardware.enable = lib.mkEnableOption "hardware";

  config = lib.mkIf config.greenery.hardware.enable {
    # Define host platform
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
