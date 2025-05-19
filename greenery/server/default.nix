{lib, ...}: {
  imports = [
    ./immich.nix
    ./minecraft
    ./nix-fabric-minecraft
  ];

  options.servModule.enable = lib.mkEnableOption "Enable Server Modules";
}
