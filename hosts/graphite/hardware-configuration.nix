{
  lib,
  ...
}:{
  # Disable Bootloaders as WSL does its own thing
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
}
